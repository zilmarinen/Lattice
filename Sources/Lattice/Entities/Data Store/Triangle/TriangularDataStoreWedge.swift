//
//  TriangularDataStoreWedge.swift
//  Lattice
//
//  Created by Zack Brown on 07/03/2026.
//

import Deltille

public struct TriangularDataStoreWedge<V: Codable>: DataStoreWedge {
    
    public typealias Tiles = [Triangle.Vertex : V]
    
    public let data: Tiles
    
    internal init(tiles: Tiles) {
        
        self.data = tiles
    }
}
