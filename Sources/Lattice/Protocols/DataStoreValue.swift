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
    
    var footprint: Set<C> { get }
}
