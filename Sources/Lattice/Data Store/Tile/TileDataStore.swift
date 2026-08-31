//
//  TileDataStore.swift
//  Lattice
//
//  Created by Zack Brown on 22/08/2026.
//

import Deltille
import SpriteKit

public class TileDataStore<T: Tile,
                           V: DataStoreValue>: SKNode,
                                               DataStore where V.C == T {
    
    internal typealias C = DataStoreChunk<T, V>
    internal typealias R = DataStoreRegion<C, T, V>
}
