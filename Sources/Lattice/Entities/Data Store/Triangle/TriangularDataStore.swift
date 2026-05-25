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
        
        guard let region = region(for: key,
                                  .tile) else { return nil }
        
        return region.value(for: key)
    }
    
    public func set(_ value: V,
                    for key: Triangle) {
        
        let footprint = value.footprint.map { Triangle($0) }
        
        for triangle in footprint {
            
            guard self.value(for: triangle) == nil else { return }
        }
        
        let unique = footprint.unique(.tile,
                                      .region)
        
        var remaining = Set(footprint)
        
        for triangle in unique {
            
            let region = region(for: triangle,
                                .region) ?? R(triangle)
            
            if region.parent == nil {
                
                addChild(region)
            }
            
            let tiles = remaining.filter {
                
                $0.transpose(.tile,
                             .region) == triangle
            }
            
            remaining.subtract(tiles)
            
            tiles.forEach {
             
                region.set(value,
                           for: $0)
            }
        }
    }
    
    public func remove(values keys: [Triangle]) {
        
        //TODO: Check footprint of items being removed to ensure
        //entire footprint is removed from the data store
        let unique = keys.unique(.tile,
                                 .region)
        
        var remaining = Set(keys)
        
        for triangle in unique {
            
            guard let region = region(for: triangle,
                                      .region) else { continue }
            
            let tiles = Array(remaining.filter {
                
                $0.transpose(.tile,
                             .region) == triangle
            })
            
            remaining.subtract(tiles)
            
            region.remove(values: tiles)
            
            guard region.numberOfDescendants == 0 else { continue }
            
            region.removeFromParent()
        }
    }
    
    public func wedge(for sieve: Triangle.Sieve) -> W {
        
        let data = sieve.triangles.reduce(into: [C.K : C.V]()) { result, triangle in
            
            result[triangle.vertex] = value(for: triangle)
        }
        
        return .init(data: data)
    }
}
