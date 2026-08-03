//
//  DataStoreChunk.swift
//  Lattice
//
//  Created by Zack Brown on 03/08/2026.
//

import Deltille

public protocol DataStoreChunk {
    
    associatedtype T: DataStoreTile
    
    var store: ValueStore<T> { get }
    
    var isEmpty: Bool { get }
    
    func merge(_ other: Self)
    
    func remove(_ keys: [T.V])
    
    func set(_ value: T)
    
    func value(for key: T.V) -> T?
}

public extension DataStoreChunk {
 
    var isEmpty: Bool {
        
        store.isEmpty
    }
}

public extension DataStoreChunk {
    
    func merge(_ other: Self) {
        
        store.data.merge(other.store.data) { (current, _) in
            
            current
        }
    }
    
    func set(_ value: T) {
        
        store.data[value.vertex] = value
    }
    
    func remove(_ keys: [T.V]) {
        
        keys.forEach {
            
            store.data.removeValue(forKey: $0)
        }
    }
    
    func value(for key: T.V) -> T? {
        
        store.data[key]
    }
}
