//
//  HexagonalLatticeSlice.swift
//  Lattice
//
//  Created by Zack Brown on 10/03/2026.
//

import Deltille

@MainActor
public struct HexagonalLatticeSlice<C: TriangularChunk,
                                    V: DataStoreValue>: LatticeSlice {
    
    public let dataStore: [HexagonalDataStoreChunk<V>]
    public let region: TriangularRegion<C>
    
    public init(dataStore: [HexagonalDataStoreChunk<V>],
                region: TriangularRegion<C>) {
        
        self.dataStore = dataStore
        self.region = region
    }
}
