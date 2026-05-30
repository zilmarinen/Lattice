//
//  DataStoreChunk.swift
//  Lattice
//
//  Created by Zack Brown on 30/05/2026.
//

import Deltille
import RealityKit

public protocol DataStoreChunk: Entity,
                                Codable {
    
    associatedtype K: Vertex
    associatedtype V: DataStoreValue
    
    var store: DataStoreComponent<K, V> { get }
    
    var data: [K : V] { get }
    
    func merge(_ other: DataStoreComponent<K, V>)
    
    func value(for key: K) -> V?
    
    func set(_ value: V,
             for key: K)
    
    func remove(values keys: [K])
}

public extension DataStoreChunk {
    
    var data: [K : V] {
        
        store.data
    }
    
    var isEmpty: Bool {
        
        store.isEmpty
    }
}

public extension DataStoreChunk {
    
    func merge(_ other: DataStoreComponent<K, V>) {
        
        store.data.merge(other.data) { (current, _) in current }
    }
    
    func value(for key: K) -> V? {
        
        data[key]
    }
    
    func set(_ value: V,
             for key: K) {
        
        store.data[key] = value
    }
    
    func remove(values keys: [K]) {
        
        keys.forEach {
            
            store.data.removeValue(forKey: $0)
        }
    }
}

