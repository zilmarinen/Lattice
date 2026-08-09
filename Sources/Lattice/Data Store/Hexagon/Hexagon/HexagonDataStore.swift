//
//  HexagonDataStore.swift
//  Lattice
//
//  Created by Zack Brown on 03/08/2026.
//

import Deltille

public class HexagonDataStore<T: DataStoreTile>: DataStore where T.T == Hexagon {
    
    internal typealias C = DataStoreChunk<V.T, V.T.S, V>
    
    internal var chunks: [C] = []
}

internal extension HexagonDataStore {
    
    func chunk(for tile: Hexagon,
               _ from: Hexagon.Scale) -> C? {
        
        let transposed = tile.transpose(from,
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
                
                chunk.parent = .zero
            }
            
            for tile in footprint {
                
                guard tile.transpose(.tile,
                                     .chunk) == chunk.tile else { continue }
                
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
public class ExampleHexagonDataStore: HexagonDataStore<ExampleHexagonTile> {
    
}
