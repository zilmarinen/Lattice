//
//  DataStore.swift
//  Lattice
//
//  Created by Zack Brown on 07/03/2026.
//

import Deltille
import RealityKit

public protocol DataStore: Entity {
    
    associatedtype C: HasDataStore
    
    associatedtype K = C.K
    associatedtype V = C.V
    associatedtype W = DataStoreWedge<C.V>
    
    func merge(_ chunks: [C])
    
    func value(for key: K) -> V?
    
    func set(_ value: V,
             for key: K)
    
    func remove(values keys: [K])
    
    func wedge(for sieve: Triangle.Sieve) -> W
}

