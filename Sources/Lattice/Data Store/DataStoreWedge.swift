//
//  DataStoreWedge.swift
//  Lattice
//
//  Created by Zack Brown on 04/09/2026.
//

import Deltille

public struct DataStoreWedge<K: Coordinate,
                             V: DataStoreValue>: Wedge {
    
    public let data: [K : V]
}

public extension DataStoreWedge {
    
    func weave<T: Tile,
               S: Sieve>(_ sieve: S) -> Weave<T, V> where K == T.V,
                                                          S == T.SI {
        
        let data = sieve.tiles.reduce(into: [T : Stitch<T, V>]()) { result, tile in
            
            let values = tile.vertices(.tile).reduce(into: [T.V : V]()) { result, vertex in
                
                guard let value = self.data[vertex] else { return }
                
                result[vertex] = value
            }

            guard !values.isEmpty else { return }

            result[tile] = .init(tile: tile,
                                 values: values)
        }
        
        return .init(data: data)
    }
}
