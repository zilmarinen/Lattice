//
//  v.swift
//  Lattice
//
//  Created by Zack Brown on 04/09/2026.
//

import Deltille

public struct LatticeSlice<C: TileChunk<T>,
                           P: Tile,
                           T: Tile,
                           V: DataStoreValue> : Slice {
    
    public let chunks: [DataStoreChunk<P, V>]
    public let region: TileRegion<C, T>
}
