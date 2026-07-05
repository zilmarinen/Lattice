//
//  DataStoreValue.swift
//  Lattice
//
//  Created by Zack Brown on 08/03/2026.
//

import Deltille

public protocol DataStoreValue: Codable,
                                Hashable,
                                Sendable {
    
    var coord: Coordinate { get }
}

public extension DataStoreValue {
    
    var vertex: Triangle.Vertex {
        
        .init(coord)
    }
}
