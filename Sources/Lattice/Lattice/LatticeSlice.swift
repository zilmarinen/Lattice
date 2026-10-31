//
//  LatticeSlice.swift
//  Lattice
//
//  Created by Zack Brown on 04/09/2026.
//

import Deltille

public struct LatticeSlice<C: TileChunk<T>,
                           P: Tile,
                           T: Tile,
                           V: DataStoreValue>: @MainActor Codable, Slice {
    
    public let chunks: [DataStoreChunk<P, V>]
    public let region: TileRegion<C, T>
}

public extension LatticeSlice {
 
    var isEmpty: Bool {
        
        chunks.isEmpty
    }
}

public extension LatticeSlice {
    
    @MainActor
    func remove(keys: Set<V.K>) {
        
        chunks.forEach {
            
            $0.remove(keys)
        }
        
        region.chunks.forEach {
            
            $0.becomeDirty()
        }
        
        region.becomeDirty()
    }
}
