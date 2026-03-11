//
//  DataStoreWedge.swift
//  Lattice
//
//  Created by Zack Brown on 07/03/2026.
//

import Deltille

public protocol DataStoreWedge {
    
    associatedtype V: Codable
    
    typealias Slice = [Triangle.Vertex : V]
    
    var data: Slice { get }
    
    var isEmpty: Bool { get }
    
    var tiles: [V] { get }
    
    func tile(for key: Triangle.Vertex) -> V?
}

public extension DataStoreWedge {
    
    var isEmpty: Bool {
        
        data.isEmpty
    }
    
    var tiles: [V] {
     
        Array(data.values)
    }
 
    func tile(for key: Triangle.Vertex) -> V? {
        
        data[key]
    }
}
