//
//  HexagonalDataStoreWedge.swift
//  Lattice
//
//  Created by Zack Brown on 08/03/2026.
//

import Deltille

public struct HexagonalDataStoreWedge<V: Codable>: DataStoreWedge {
    
    public typealias Tiles = [Triangle.Vertex : HexagonalDataStoreTile<V>]
    internal typealias Vertices = [Triangle.Vertex : V]
    
    public let data: Tiles
    
    internal init(tiles: Tiles) {
        
        self.data = tiles
    }
}
