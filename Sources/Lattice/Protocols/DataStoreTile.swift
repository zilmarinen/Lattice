//
//  DataStoreTile.swift
//  Lattice
//
//  Created by Zack Brown on 03/08/2026.
//

import Deltille

public protocol DataStoreTile: Codable,
                               DataStoreValue,
                               Hashable where T == V {
    
    associatedtype T: Tile
    
    var footprint: [T] { get }
    
    var rotation: T.R { get }
}

//TODO: REMOVE
public struct ExampleTriangleTile: DataStoreTile {
    
    public let vertex: Triangle
    
    public let footprint: [Triangle]
    
    public let rotation: Triangle.Rotation
}

//TODO: REMOVE
public struct ExampleHexagonTile: DataStoreTile {
    
    public let vertex: Hexagon
    
    public let footprint: [Hexagon]
    
    public let rotation: Hexagon.Rotation
}
