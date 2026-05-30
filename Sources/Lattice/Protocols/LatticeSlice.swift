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
    associatedtype K = Vertex
    
    var region: TriangularRegion<C> { get }
    var stores: [DSC] { get }
    
    var isEmpty: Bool { get }
        
    func remove(values keys: [K])
}

public extension LatticeSlice {
    
    var isEmpty: Bool {
        
        stores.isEmpty
    }
}
