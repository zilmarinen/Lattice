//
//  DataStoreSlice.swift
//  Lattice
//
//  Created by Zack Brown on 04/09/2026.
//

import Deltille

public struct DataStoreSlice<C: GridChunk<T>,
                             T: Tile,
                             V: DataStoreValue> : Slice {
    
    public let chunks: [DataStoreChunk<T, V>]
    public let region: GridRegion<C, T>
}
