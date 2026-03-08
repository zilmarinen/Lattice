//
//  GridDataStore.swift
//  Lattice
//
//  Created by Zack Brown on 07/03/2026.
//

import Deltille
import RealityKit

internal protocol GridDataStore: Entity {
    
    associatedtype C: HasDataStore
    associatedtype S: DataStoreSlice
    
    associatedtype K = C.K
    associatedtype V = C.V
    
    func merge(_ chunks: [C])
    
    func value(for key: K) -> V?
    
    func set(_ value: V?,
             for key: K)
    
    func remove(values keys: [K])
    
    func slice(for sieve: Triangle.Sieve) -> S
}

internal extension GridDataStore {
    
    func remove(values keys: [K]) {
     
        keys.forEach {
            
            set(nil,
                for: $0)
        }
    }
}
