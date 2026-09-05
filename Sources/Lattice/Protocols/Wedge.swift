//
//  Wedge.swift
//  Lattice
//
//  Created by Zack Brown on 04/09/2026.
//

import Deltille

public protocol Wedge {
    
    associatedtype K: Coordinate
    associatedtype V: DataStoreValue
    
    var data: [K : V] { get }
    
    var isEmpty: Bool { get }
    
    func value(for key: K) -> V?
}

public extension Wedge {
    
    var isEmpty: Bool {
        
        data.isEmpty
    }
}

public extension Wedge {
    
    func value(for key: K) -> V? {
        
        data[key]
    }
}
