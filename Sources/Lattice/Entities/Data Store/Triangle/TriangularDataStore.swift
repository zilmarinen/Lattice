//
//  TriangularDataStore.swift
//  Lattice
//
//  Created by Zack Brown on 07/03/2026.
//

import Deltille
import RealityKit

public class TriangularDataStore<R: TriangularDataStoreRegion<C, V>,
                                 C: TriangularDataStoreChunk<V>,
                                 V: TriangularDataStoreTile>: TriangularGrid<R, C>,
                                                              DataStore {
    
    public func merge(_ chunks: [C]) {
        
        chunks.forEach {
            
            let region = region(for: $0.triangle,
                                .chunk) ?? R($0.triangle.transpose(.chunk,
                                                                   .region))
            
            if region.parent == nil {
                
                addChild(region)
            }
            
            region.merge($0)
        }
    }
    
    public func value(for key: Triangle) -> V? {
        
        guard let chunk = chunk(for: key,
                                .tile) else { return nil }
        
        return chunk.value(for: key.vertex.position)
    }
    
    public func set(_ value: V,
                    for key: Triangle) {
        
        guard !intersects(value) else { return }
        
        let unique = Set(value.footprint.map {
            
            let triangle = Triangle($0)
            
            return triangle.transpose(.tile,
                                      .region)
        })
        
        for triangle in unique {
            
            let region = region(for: triangle,
                                .region) ?? R(triangle)
            
            if region.parent == nil {
                
                addChild(region)
            }
            
            region.set(value,
                       for: key)
        }
    }
     
    public func remove(values keys: [Triangle]) {
        
        let tiles = values(for: keys)
        
        let unique = tiles.reduce(into: [Triangle : [Triangle]]()) { result, triangle in
            
            let region = triangle.transpose(.tile,
                                            .region)
            
            var values = result[region] ?? Array()
            
            values.append(triangle)
            
            result[region] = values
        }
        
        for (triangle, values) in unique {
            
            guard let region = region(for: triangle,
                                      .region) else { continue }
            
            region.remove(values: values)
            
            guard region.numberOfDescendants == 0 else { continue }
            
            region.removeFromParent()
        }
    }
    
    public func wedge(for sieve: Triangle.Sieve) -> W {
        
        let data = sieve.triangles.reduce(into: [Triangle.Vertex : C.V]()) { result, triangle in
            
            result[triangle.vertex] = value(for: triangle)
        }
        
        return .init(data: data)
    }
}

extension TriangularDataStore {
    
    private func intersects(_ value: V) -> Bool {
        
        let footprint = Set(value.footprint + [value.vertex])
        
        let tiles = footprint.map {
            
            Triangle($0)
        }
        
        return !values(for: tiles).isEmpty
    }
    
    private func values(for keys: [Triangle]) -> [Triangle] {
        
        var visited = Set<Triangle>()
        
        for key in keys {
            
            guard !visited.contains(key),
                  let value = value(for: key) else { continue }
            
            let footprint = Set(value.footprint + [value.vertex])
            
            visited.formUnion(footprint.map {
                
                Triangle($0)
            })
        }
        
        return Array(visited)
    }
}
