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
    associatedtype DS: HasDataStore
    
    var region: TriangularRegion<C> { get }
    var dataStore: [DS] { get }
    
    var isEmpty: Bool { get }
        
    func remove(values keys: [DS.K])
}

public extension LatticeSlice {
    
    var isEmpty: Bool {
        
        dataStore.isEmpty
    }
    
    func remove(values keys: [DS.K]) {
        
        dataStore.forEach {
            
            $0.remove(values: keys)
        }
        
        region.chunks.forEach {
            
            $0.becomeDirty()
        }
        
        region.becomeDirty()
    }
}
