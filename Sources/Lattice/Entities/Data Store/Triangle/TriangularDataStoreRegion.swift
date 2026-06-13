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
    
    internal func set(_ value: V,
                      for key: Triangle) {
        
        let unique = value.footprint.reduce(into: [Triangle : [Triangle]]()) { result, vertex in
            
            let tile = Triangle(vertex)
            
            guard tile.transpose(.tile,
                                 .region) == triangle else { return }
            
            let chunk = tile.transpose(.tile,
                                       .chunk)
            
            var values = result[chunk] ?? Array()
            
            values.append(tile)
            
            result[chunk] = values
        }
        
        for (triangle, values) in unique {
            
            let chunk = chunk(for: triangle,
                              .chunk) ?? C(triangle)
            
            if chunk.parent == nil {
                
                addChild(chunk)
            }
            
            for tile in values {
             
                chunk.set(value,
                          for: tile.vertex.position)
            }
        }
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
            
            chunk.remove(values: tiles.map { $0.vertex.position })
            
            guard chunk.isEmpty else { continue }
            
            chunk.removeFromParent()
        }
    }
}
