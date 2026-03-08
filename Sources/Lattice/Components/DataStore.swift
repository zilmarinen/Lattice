//
//  DataStore.swift
//  Lattice
//
//  Created by Zack Brown on 07/03/2026.
//

import Deltille
import RealityKit

internal class DataStore<K: Codable & Hashable,
                         V: Codable>: Component,
                                      Codable {
    
    internal var data: [K : V] = [:]
    
    internal var isEmpty: Bool {
        
        data.isEmpty
    }
}

internal protocol HasDataStore: Entity {
    
    associatedtype K: Codable & Hashable
    associatedtype V: Codable
    
    var store: DataStore<K, V> { get }
    
    var data: [K : V] { get }
    
    func merge(_ other: DataStore<K, V>)
    
    func value(for key: K) -> V?
    
    func set(_ value: V?,
             for key: K)
    
    func remove(values keys: [K])
}

extension HasDataStore {
    
    internal var data: [K : V] {
        
        store.data
    }
    
    internal var isEmpty: Bool {
        
        store.isEmpty
    }
}

extension HasDataStore {
    
    internal func merge(_ other: DataStore<K, V>) {
        
        store.data.merge(other.data) { (current, _) in current }
    }
    
    internal func value(for key: K) -> V? {
        
        data[key]
    }
    
    internal func remove(values keys: [K]) {
        
        keys.forEach {
            
            store.data.removeValue(forKey: $0)
        }
    }
}
