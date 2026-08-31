//
//  Lattice.swift
//  Lattice
//
//  Created by Zack Brown on 29/08/2026.
//

import Deltille
import SpriteKit

internal protocol Lattice: SKNode {
    
    associatedtype C: GridChunk<T>
    associatedtype G: Grid<R, C, T>
    associatedtype R: GridRegion<C, T>
    associatedtype S: DataStore
    associatedtype T: Tile
    associatedtype V: DataStoreValue
    
    var grid: G { get }
    var store: S { get }
    
    func remove(_ keys: Set<V.C>)
    
    func set(_ value: V)
    
    func value(for key: V.C) -> V?
}
