//
//  DataStoreSlice.swift
//  Lattice
//
//  Created by Zack Brown on 07/03/2026.
//

import Deltille

internal protocol DataStoreSlice {
    
    associatedtype V: Codable
    
    typealias Slice = [Triangle.Vertex : V]
    
    var data: Slice { get }
    
    var isEmpty: Bool { get }
    
    var tiles: [V] { get }
    
    func tile(for key: Triangle.Vertex) -> V?
}

extension DataStoreSlice {
    
    internal var isEmpty: Bool {
        
        data.isEmpty
    }
    
    internal var tiles: [V] {
     
        Array(data.values)
    }
 
    internal func tile(for key: Triangle.Vertex) -> V? {
        
        data[key]
    }
}
