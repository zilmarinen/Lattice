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
    
    associatedtype K: Coordinate
    associatedtype T: Tile
    
    var vertex: K { get }
    
    var footprint: Set<K> { get }
}
