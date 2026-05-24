//
//  TriangularDataStore.swift
//  Lattice
//
//  Created by Zack Brown on 07/03/2026.
//

import Deltille
import RealityKit

public class TriangularDataStoreRegion<C: TriangularDataStoreChunk<V>,
                                       V: TriangularDataStoreTile>: TriangularRegion<C> {
    
    internal func merge(_ chunk: C) {
        
        guard let existing = self.chunk(for: chunk.triangle,
                                        .chunk) else {
            
            return addChild(chunk)
        }
        
        existing.merge(chunk.store)
    }
    
    internal func value(for key: Triangle) -> V? {
        
        guard let chunk = chunk(for: key,
                                .tile) else { return nil }
        
        return chunk.value(for: key.vertex)
    }
    
    internal func set(_ value: V,
                      for key: Triangle) {
        
        let chunk = chunk(for: key,
                          .tile) ?? C(key.transpose(.tile,
                                                    .chunk))
        
        if chunk.parent == nil {
            
            addChild(chunk)
        }
        
        chunk.set(value,
                  for: key.vertex)
    }
    
    internal func remove(values keys: [Triangle]) {
     
        let unique = keys.unique(.tile,
                                 .chunk)
        
        var remaining = Set(keys)
        
        for triangle in unique {
            
            guard let chunk = chunk(for: triangle,
                                    .chunk) else { continue }
            
            let tiles = remaining.filter {
                
                $0.transpose(.tile,
                             .chunk) == triangle
            }
            
            remaining.subtract(tiles)
            
            chunk.remove(values: tiles.map { $0.vertex })
            
            guard chunk.isEmpty else { continue }
            
            chunk.removeFromParent()
        }
        
        becomeDirty()
    }
}
