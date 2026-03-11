//
//  DataStoreRegion.swift
//  Lattice
//
//  Created by Zack Brown on 07/03/2026.
//

import RealityKit

public protocol DataStoreRegion: Entity {
    
    associatedtype C: HasDataStore
    
    associatedtype K = C.K
    associatedtype V = C.V
    
    func merge(_ chunk: C)
    
    func value(for key: K) -> V?
    
    func set(_ value: V?,
             for key: K)
}
