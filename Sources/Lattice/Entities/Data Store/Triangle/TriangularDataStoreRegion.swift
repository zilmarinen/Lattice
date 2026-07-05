//
//  TriangularDataStore.swift
//  Lattice
//
//  Created by Zack Brown on 07/03/2026.
//

import Deltille
import RealityKit

public class TriangularDataStoreRegion<C: TriangularDataStoreChunk<V>,
                                       V: TriangularDataStoreTile>: DataStoreContainer<Triangle, Triangle.Scale> {
    
    required public init(_ triangle: Triangle) {
        
        super.init(triangle,
                   .region)
    }
    
    required public init(from decoder: any Decoder) throws {
        
        try super.init(from: decoder)
    }
}

internal extension TriangularDataStoreRegion {
    
    var chunks: [C] {
        
        children?.compactMap {
            
            $0 as? C
            
        } ?? []
    }
}

internal extension TriangularDataStoreRegion {
    
    func chunk(for triangle: Triangle,
               _ from: Triangle.Scale) -> C? {
        
        let chunk = triangle.transpose(from,
                                       .chunk)
        
        return chunks.first {
            
            $0.tile == chunk
        }
    }
    
    func chunks(intersecting triangle: Triangle,
                _ from: Triangle.Scale) -> [C] {
        
        let chunk = triangle.transpose(from,
                                       .chunk)
        
        return chunks.filter {
            
            $0.tile == chunk
        }
    }
}

internal extension TriangularDataStoreRegion {
    
    func merge(_ chunk: C) {
        
        guard let existing = self.chunk(for: chunk.tile,
                                        .chunk) else {
            
            return add(child: chunk)
        }
        
        existing.merge(chunk.store)
    }
    
    func set(_ value: V,
             for key: Triangle) {
        
        let tiles = value.tiles
        
        let unique = tiles.unique(.tile,
                                  .chunk)
        
        for triangle in unique {
            
            let chunk = chunk(for: triangle,
                              .chunk) ?? C(triangle)
            
            if chunk.parent == nil {
                
                add(child: chunk)
            }
            
            for tile in tiles {
                
                guard tile.transpose(.tile,
                                     .chunk) == triangle else { continue }
                
                chunk.set(value,
                          for: tile.vertex.position)
            }
        }
    }
    
    func remove(values keys: [Triangle]) {
     
        let unique = keys.unique(.tile,
                                 .chunk)
        
        for triangle in unique {
            
            guard let chunk = chunk(for: triangle,
                                    .chunk) else { continue }
            
            let values: [Coordinate] = keys.compactMap {
                
                guard $0.transpose(.tile,
                                   .chunk) == triangle else { return nil }
                
                return $0.vertex.position
            }
            
            chunk.remove(values: values)
            
            guard chunk.isEmpty else { continue }
            
            chunk.removeFromParent()
        }
    }
}
