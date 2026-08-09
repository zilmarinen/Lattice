//
//  TriangleDataStoreRegion.swift
//  Lattice
//
//  Created by Zack Brown on 03/08/2026.
//

import Deltille

public class TriangleDataStoreRegion<T: DataStoreTile>: DataStoreContainer<Triangle, Triangle.Scale> where T.T == Triangle {
    
    internal typealias C = DataStoreChunk<T.T, T.T.S, T>

    internal var chunks: [C] = []
}

internal extension TriangleDataStoreRegion {
    
    var isEmpty: Bool {
        
        chunks.isEmpty
    }
}

internal extension TriangleDataStoreRegion {
    
    func chunk(for tile: Triangle,
               _ from: Triangle.Scale) -> C? {
        
        let transposed = tile.transpose(from,
                                        .chunk)
        
        return chunks.first {
            
            $0.tile == transposed
        }
    }
    
    func remove(_ keys: [T.V]) {
     
        let unique = keys.unique(.tile,
                                 .chunk)
        
        for tile in unique {
            
            guard let chunk = chunk(for: tile,
                                    .chunk) else { continue }
            
            chunk.remove(keys)
            
            guard chunk.isEmpty,
                  let index = chunks.firstIndex(of: chunk) else { continue }
            
            chunks.remove(at: index)
        }
    }
    
    func set(_ value: T) {
        
        let footprint = value.footprint
        
        let unique = footprint.unique(.tile,
                                      .chunk)
        
        for tile in unique {
            
            let chunk = chunk(for: tile,
                              .chunk) ?? C(tile,
                                           .chunk)
            
            if chunk.parent == nil {
                
                chunks.append(chunk)
                
                chunk.parent = self.tile
            }
            
            for tile in footprint {
                
                guard tile.transpose(.tile,
                                     .chunk) == chunk.tile else { continue }
                
                chunk.set(value)
            }
        }
    }
}

//TODO: REMOVE
public class ExampleTriangleDataStoreRegion: TriangleDataStoreRegion<ExampleTriangleTile> {
    
}
