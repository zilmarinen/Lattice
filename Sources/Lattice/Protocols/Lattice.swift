//
//  Lattice.swift
//  Lattice
//
//  Created by Zack Brown on 29/08/2026.
//

import Deltille
import SpriteKit

internal protocol Lattice: SKNode where S.T == T,
                                        S.V == V {
    
    associatedtype C: GridChunk<T>
    associatedtype G: Grid<R, C, T>
    associatedtype R: GridRegion<C, T>
    associatedtype S: DataStore
    associatedtype T: Tile
    associatedtype V: DataStoreValue
    
    var grid: G { get }
    var store: S { get }
    
    func remove(_ keys: Set<S.V.C>)
    
    func set(_ value: V)
    
    func value(for key: V.C) -> V?
}

internal extension Lattice {
    
    func remove(_ keys: Set<V.C>) {
        
        let chunks = store.remove(keys)
        
        grid.propagate(chunks)
    }
    
    func set(_ value: V) {
        
        let chunks = store.set(value)
        
        grid.propagate(chunks,
                       true)
    }
    
    func value(for key: V.C) -> V? {
    
        store.value(for: key)
    }
}
