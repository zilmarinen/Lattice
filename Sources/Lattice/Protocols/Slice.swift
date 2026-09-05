//
//  Slice.swift
//  Lattice
//
//  Created by Zack Brown on 04/09/2026.
//

import Deltille

public protocol Slice {
    
    associatedtype C: GridChunk<T>
    associatedtype T: Tile
    associatedtype V: DataStoreValue
    
    var chunks: [DataStoreChunk<T, V>] { get }
    var region: GridRegion<C, T> { get }
}
