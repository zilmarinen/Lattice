//
//  LatticeSlice.swift
//  Lattice
//
//  Created by Zack Brown on 11/03/2026.
//

import Deltille

@MainActor
public protocol LatticeSlice: Codable,
                              Equatable,
                              Hashable {
    
    associatedtype C: TriangularChunk
    associatedtype DSC: DataStoreChunk
    
    var region: TriangularRegion<C> { get }
    var stores: [DSC] { get }
    
    var isEmpty: Bool { get }
        
    func remove(values keys: [DSC.K])
}

public extension LatticeSlice {
    
    var isEmpty: Bool {
        
        stores.isEmpty
    }
    
    func remove(values keys: [DSC.K]) {
        
        stores.forEach {
            
            $0.remove(values: keys)
        }
        
        region.chunks.forEach {
            
            $0.becomeDirty()
        }
        
        region.becomeDirty()
    }
}
