//
//  TriangularDataStoreTile.swift
//  Lattice
//
//  Created by Zack Brown on 10/03/2026.
//

import Deltille

public protocol TriangularDataStoreTile: Codable,
                                         DataStoreValue,
                                         Hashable {
    
    var footprint: [Triangle.Vertex] { get }
    
    var rotation: Triangle.Rotation { get }
}
