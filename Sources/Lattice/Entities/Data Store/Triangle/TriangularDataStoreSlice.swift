//
//  TriangularDataStoreSlice.swift
//  Lattice
//
//  Created by Zack Brown on 07/03/2026.
//

import Deltille

public struct TriangularDataStoreSlice<V: Codable>: DataStoreSlice {
    
    public typealias Tiles = [Triangle.Vertex : V]
    
    public let data: Tiles
    
    internal init(tiles: Tiles) {
        
        self.data = tiles
    }
}
