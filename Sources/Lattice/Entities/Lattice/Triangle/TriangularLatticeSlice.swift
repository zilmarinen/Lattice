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
    
    public let stores: [TriangularDataStoreChunk<V>]
    public let region: TriangularRegion<C>
    
    internal init(stores: [TriangularDataStoreChunk<V>],
                  region: TriangularRegion<C>) {
        
        self.stores = stores
        self.region = region
    }
}

public extension TriangularLatticeSlice {
    
    func remove(values keys: [Triangle]) {
        
        let keys = keys.map { $0.vertex.position }
        
        stores.forEach {
            
            $0.remove(values: keys)
        }
        
        region.chunks.forEach {
            
            $0.becomeDirty()
        }
        
        region.becomeDirty()
    }
}
