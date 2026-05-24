//
//  TriangularLatticeSlice.swift
//  Lattice
//
//  Created by Zack Brown on 10/03/2026.
//

import Deltille

@MainActor
public struct TriangularLatticeSlice<C: TriangularChunk,
                                     V: TriangularDataStoreTile>: LatticeSlice {
    
    public let dataStore: [TriangularDataStoreChunk<V>]
    public let region: TriangularRegion<C>
    
    internal init(dataStore: [TriangularDataStoreChunk<V>],
                  region: TriangularRegion<C>) {
        
        self.dataStore = dataStore
        self.region = region
    }
}
