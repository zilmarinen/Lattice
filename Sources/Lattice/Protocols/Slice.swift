//
//  Slice.swift
//  Lattice
//
//  Created by Zack Brown on 04/09/2026.
//

import Deltille

public protocol Slice {
    
    associatedtype C: TileChunk<T>
    associatedtype P: Tile
    associatedtype T: Tile
    associatedtype V: DataStoreValue
    
    var chunks: [DataStoreChunk<P, V>] { get }
    var region: TileRegion<C, T> { get }
}
