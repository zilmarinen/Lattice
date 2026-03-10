//
//  HexagonalDataStoreSlice.swift
//  Lattice
//
//  Created by Zack Brown on 08/03/2026.
//

import Deltille

public struct HexagonalDataStoreSlice<V: Codable>: DataStoreSlice {
    
    public typealias Tiles = [Triangle.Vertex : HexagonalDataStoreTile<V>]
    internal typealias Vertices = [Triangle.Vertex : V]
    
    public let data: Tiles
    
    internal init(sieve: Triangle.Sieve,
                  vertices: Vertices) {
        
        self.data = sieve.tiles.reduce(into: Tiles()) { result, tile in
            
            let vertices = tile.vertices.reduce(into: Vertices()) { result, vertex in
                
                guard let value = vertices[vertex] else { return }
             
                result[vertex] = value
            }

            guard !vertices.isEmpty else { return }

            result[tile.vertex] = .init(tile: tile,
                                        vertices: vertices)
        }
    }
}
