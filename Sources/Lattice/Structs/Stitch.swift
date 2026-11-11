//
//  Stitch.swift
//  Lattice
//
//  Created by Zack Brown on 11/11/2026.
//

import Deltille

public struct Stitch<T: Tile,
                     V: DataStoreValue> {
    
    public let tile: T
    public let values: [T.V : V]
}
