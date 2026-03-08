//
//  TriangularDataStoreSlice.swift
//  Lattice
//
//  Created by Zack Brown on 07/03/2026.
//

import Deltille

internal struct TriangularDataStoreSlice<V: Codable>: DataStoreSlice {
    
    internal typealias Tiles = [Triangle.Vertex : V]
    
    internal let data: Tiles
    
    internal init(tiles: Tiles) {
        
        self.data = tiles
    }
}
