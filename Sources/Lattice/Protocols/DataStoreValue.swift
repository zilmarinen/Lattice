//
//  DataStoreValue.swift
//  Lattice
//
//  Created by Zack Brown on 22/08/2026.
//

import Deltille

public protocol DataStoreValue: Codable,
                                Hashable,
                                Sendable {
    
    associatedtype C: Coordinate
    
    var vertex: C { get }
    
    var footprint: [C] { get }
}

//TODO: REMOVE
public struct ExampleTriangleVertexValue: DataStoreValue {
    
    public let vertex: Triangle.Vertex
    
    public let footprint: [Triangle.Vertex]
}

//TODO: REMOVE
public struct ExampleTriangleValue: DataStoreValue {
    
    public let vertex: Triangle
    
    public var footprint: [Triangle]
}
