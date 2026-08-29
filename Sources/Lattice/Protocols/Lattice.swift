//
//  Lattice.swift
//  Lattice
//
//  Created by Zack Brown on 29/08/2026.
//

import Deltille
import SpriteKit

internal protocol Lattice: SKNode {
    
    associatedtype V: DataStoreValue
    
    func remove(_ keys: Set<V.C>)
    
    func set(_ value: V)
    
    func value(for key: V.C) -> V?
}
