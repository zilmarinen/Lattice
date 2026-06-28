//
//  DataStoreChunk.swift
//  Lattice
//
//  Created by Zack Brown on 30/05/2026.
//

import Deltille
import RealityKit

public protocol DataStoreChunk: Codable {
    
    associatedtype V: DataStoreValue
    
    var store: DataStoreComponent<V> { get }
    
    var data: [Coordinate : V] { get }
    
    func merge(_ other: DataStoreComponent<V>)
    
    func value(for key: Coordinate) -> V?
    
    func set(_ value: V,
             for key: Coordinate)
    
    func remove(values keys: [Coordinate])
}

public extension DataStoreChunk {
    
    var data: [Coordinate : V] {
        
        store.data
    }
    
    var isEmpty: Bool {
        
        store.isEmpty
    }
}

public extension DataStoreChunk {
    
    func merge(_ other: DataStoreComponent<V>) {
        
        store.data.merge(other.data) { (current, _) in current }
    }
    
    func value(for key: Coordinate) -> V? {
        
        data[key]
    }
    
    func set(_ value: V,
             for key: Coordinate) {
        
        store.data[key] = value
    }
    
    func remove(values keys: [Coordinate]) {
        
        keys.forEach {
            
            store.data.removeValue(forKey: $0)
        }
    }
}
