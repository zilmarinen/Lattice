//
//  DataStoreComponent.swift
//  Lattice
//
//  Created by Zack Brown on 07/03/2026.
//

import Deltille
import RealityKit

public class DataStoreComponent<K: Vertex,
                                V: Codable>: Component,
                                             Codable {
    
    public internal(set) var data: [K : V] = [:]
    
    internal var isEmpty: Bool {
        
        data.isEmpty
    }
}

public protocol HasDataStore: Entity,
                              Codable {
    
    associatedtype K: Vertex
    associatedtype V: Codable
    
    var store: DataStoreComponent<K, V> { get }
    
    var data: [K : V] { get }
    
    func merge(_ other: DataStoreComponent<K, V>)
    
    func value(for key: K) -> V?
    
    func set(_ value: V,
             for key: K)
    
    func remove(values keys: [K])
}

public extension HasDataStore {
    
    var data: [K : V] {
        
        store.data
    }
    
    var isEmpty: Bool {
        
        store.isEmpty
    }
}

public extension HasDataStore {
    
    func merge(_ other: DataStoreComponent<K, V>) {
        
        store.data.merge(other.data) { (current, _) in current }
    }
    
    func value(for key: K) -> V? {
        
        data[key]
    }
}
