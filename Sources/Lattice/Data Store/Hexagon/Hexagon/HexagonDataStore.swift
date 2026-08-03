//
//  HexagonDataStore.swift
//  Lattice
//
//  Created by Zack Brown on 03/08/2026.
//

import Deltille

public class HexagonDataStore<C: HexagonDataStoreChunk<T>,
                              T: DataStoreTile>: DataStore where T.T == Hexagon,
                                                                 T.T == T.V {
    
    internal var chunks: [C] = []
}

internal extension HexagonDataStore {
    
    func chunk(for triangle: Hexagon,
               _ from: Hexagon.Scale) -> C? {
        
        let transposed = triangle.transpose(from,
                                            .chunk)
        
        return chunks.first {
            
            $0.tile == transposed
        }
    }
}

public extension HexagonDataStore {
    
    func remove(_ keys: [T.V]) {
     
        let unique = keys.unique(.tile,
                                 .chunk)
        
        for triangle in unique {
            
            guard let chunk = chunk(for: triangle,
                                    .chunk) else { continue }
            
            let values: [T.V] = keys.compactMap {
                
                $0.transpose(.tile,
                             .chunk) == triangle ? $0 : nil
            }
            
            chunk.remove(values)
            
            guard chunk.isEmpty,
                  let index = chunks.firstIndex(of: chunk) else { continue }
            
            chunks.remove(at: index)
        }
    }
    
    func set(_ value: T) {
        
        let footprint = value.footprint
        
        let unique = footprint.unique(.tile,
                                      .chunk)
        
        for triangle in unique {
            
            let chunk = chunk(for: triangle,
                              .chunk) ?? C(triangle)
            
            if chunks.firstIndex(of: chunk) == nil {
                
                chunks.append(chunk)
            }
            
            for tile in footprint {
                
                guard tile.transpose(.tile,
                                     .chunk) == triangle else { continue }
                
                chunk.set(value)
            }
        }
    }
    
    func value(for key: T.V) -> T? {
        
        guard let chunk = chunk(for: key,
                                .tile) else { return nil }
        
        return chunk.value(for: key)
    }
}

//TODO: REMOVE
public class ExampleHexagonDataStore: HexagonDataStore<HexagonDataStoreChunk<ExampleHexagonTile>, ExampleHexagonTile> {
    
}
