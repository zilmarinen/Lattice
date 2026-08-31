//
//  VertexDataStore.swift
//  Lattice
//
//  Created by Zack Brown on 28/08/2026.
//

import Deltille
import SpriteKit

public class VertexDataStore<T: Tile,
                             V: DataStoreValue>: SKNode,
                                                 DataStore where V.C == T.D.V {
    
    internal typealias C = DataStoreChunk<T, V>
    internal typealias R = DataStoreRegion<C, T, V>
}
