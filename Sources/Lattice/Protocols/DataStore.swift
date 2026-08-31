//
//  DataStore.swift
//  Lattice
//
//  Created by Zack Brown on 29/08/2026.
//

import Deltille
import SpriteKit

internal protocol DataStore: SKNode {
    
    associatedtype C: DataStoreChunk<T, V>
    associatedtype R: DataStoreRegion<C, T, V>
    associatedtype T: Tile
    associatedtype V: DataStoreValue
    
    var regions: [R] { get }
    
    func region(for tile: T,
                _ from: Scale) -> R?
    
    func chunk(for tile: T,
               _ from: Scale) -> C?
    
    func remove(_ keys: Set<V.C>)
    
    func set(_ value: V)
    
    func value(for key: V.C) -> V?
}
