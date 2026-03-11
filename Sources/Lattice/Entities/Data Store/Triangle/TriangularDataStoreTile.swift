//
//  TriangularDataStoreTile.swift
//  Lattice
//
//  Created by Zack Brown on 10/03/2026.
//

import Deltille

public protocol TriangularDataStoreTile: Codable,
                                         Hashable {
    
    var origin: Triangle.Vertex { get }
    
    var footprint: Triangle.Footprint { get }
    
    var rotation: Triangle.Rotation? { get }
}
