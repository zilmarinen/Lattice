//
//  TriangularDataStore.swift
//  Lattice
//
//  Created by Zack Brown on 07/03/2026.
//

import Deltille
import RealityKit

open class TriangularDataStore<R: TriangularDataStoreRegion<C, V>,
                               C: TriangularDataStoreChunk<V>,
                               V: TriangularDataStoreTile>: TriangularDataStoreContainer,
                                                            DataStore {
    
    required public init() {
        
        super.init(.zero,
                   .region)
    }
    
    required public init(from decoder: any Decoder) throws {
        
        try super.init(from: decoder)
    }
}

internal extension TriangularDataStore {
    
    var regions: [R] {
        
        children?.compactMap {
            
            $0 as? R
            
        } ?? []
    }
}

public extension TriangularDataStore {
    
    func region(for triangle: Triangle,
                _ from: Triangle.Scale) -> R? {
        
        let region = triangle.transpose(from,
                                        .region)
        
        return regions.first {
            
            $0.triangle == region
        }
    }
    
    func chunk(for triangle: Triangle,
               _ from: Triangle.Scale) -> C? {
        
        guard let region = self.region(for: triangle,
                                       from) else { return nil }
        
        return region.chunk(for: triangle,
                            from)
    }
    
    func chunks(intersecting triangle: Triangle,
                _ from: Triangle.Scale) -> [C] {
        
        regions.flatMap {
            
            $0.chunks(intersecting: triangle,
                      from)
        }
    }
}

public extension TriangularDataStore {
    
    func merge(_ region: R) {
        
        guard let existing = self.region(for: region.triangle,
                                         .region) else {
            
            return add(child: region)
        }
        
        for chunk in region.chunks {
            
            guard existing.chunk(for: chunk.triangle,
                                 .chunk) == nil else { continue }
            
            existing.add(child: chunk)
        }
    }
    
    func merge(_ chunks: [C]) {
        
        chunks.forEach {
            
            let region = region(for: $0.triangle,
                                .chunk) ?? R($0.triangle.transpose(.chunk,
                                                                   .region))
            
            if region.parent == nil {
                
                add(child: region)
            }
            
            region.merge($0)
        }
    }
    
    func value(for key: Triangle) -> V? {
        
        guard let chunk = chunk(for: key,
                                .tile) else { return nil }
        
        return chunk.value(for: key.vertex.position)
    }
    
    func set(_ value: V,
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
                
                add(child: region)
            }
            
            region.set(value,
                       for: key)
        }
    }
     
    func remove(values keys: [Triangle]) {
        
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
            
            guard !region.hasChildren else { continue }
            
            region.removeFromParent()
        }
    }
    
    func wedge(for sieve: Triangle.Sieve) -> W {
        
        let data = sieve.triangles.reduce(into: [Triangle.Vertex : C.V]()) { result, triangle in
            
            result[triangle.vertex] = value(for: triangle)
        }
        
        return .init(data: data)
    }
}

private extension TriangularDataStore {
    
    func intersects(_ value: V) -> Bool {
        
        let footprint = Set(value.footprint + [value.vertex])
        
        let tiles = footprint.map {
            
            Triangle($0)
        }
        
        return !values(for: tiles).isEmpty
    }
    
    func values(for keys: [Triangle]) -> [Triangle] {
        
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
