//
//  HexagonalLatticeSlice.swift
//  Lattice
//
//  Created by Zack Brown on 10/03/2026.
//

import Deltille

public struct HexagonalLatticeSlice<C: TriangularChunk,
                                    V: DataStoreValue>: LatticeSlice {
    
    public let stores: [HexagonalDataStoreChunk<V>]
    public let region: TriangularRegion<C>
    
    public init(stores: [HexagonalDataStoreChunk<V>],
                region: TriangularRegion<C>) {
        
        self.stores = stores
        self.region = region
    }
}

public extension HexagonalLatticeSlice {
    
    @MainActor
    func remove(values keys: [Triangle.Vertex]) {
        
        let keys = keys.map { $0.position }
        
        stores.forEach {
            
            $0.remove(values: keys)
        }
        
        region.chunks.forEach {
            
            $0.becomeDirty()
        }
        
        region.becomeDirty()
    }
}
