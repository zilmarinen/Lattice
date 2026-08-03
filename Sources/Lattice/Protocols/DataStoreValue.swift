//
//  DataStoreValue.swift
//  Lattice
//
//  Created by Zack Brown on 03/08/2026.
//

import Deltille

public protocol DataStoreValue: Codable,
                                Hashable,
                                Sendable {
    
    associatedtype V: Coordinate
    
    var vertex: V { get }
}

//TODO: REMOVE
public struct ExampleTriangleVertexValue: DataStoreValue {
    
    public let vertex: Triangle.Vertex
}

//TODO: REMOVE
public struct ExampleHexagonVertexValue: DataStoreValue {
    
    public let vertex: Hexagon.Vertex
}
