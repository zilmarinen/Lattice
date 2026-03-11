//
//  HexagonalLattice.swift
//  Lattice
//
//  Created by Zack Brown on 10/03/2026.
//

import Deltille
import RealityKit

open class HexagonalLattice<C: TriangularChunk,
                            V: Codable>: Entity,
                                         Lattice {
    
    public typealias R = HexagonalDataStoreRegion<HexagonalDataStoreChunk<V>, V>
    
    public let dataStore = HexagonalDataStore<R, HexagonalDataStoreChunk<V>, V>()
    
    public let grid = TriangularGrid<TriangularRegion<C>, C>()
    
    public required init() {
        
        super.init()
        
        addChild(dataStore)
        addChild(grid)
    }
}

public extension HexagonalLattice {
    
    func set(_ value: V?,
             for key: Triangle.Vertex) {
        
        dataStore.set(value,
                      for: key)
        
        grid.propagate(vertex: key)
    }
    
    func wedge(for sieve: Triangle.Sieve) -> HexagonalDataStoreWedge<V> {
    
        dataStore.wedge(for: sieve)
    }
    
    func merge(_ slice: HexagonalLatticeSlice<C, V>) {
        
        dataStore.merge(slice.dataStore)
        grid.merge(slice.region)
    }
    
    func slice(region triangle: Triangle) -> HexagonalLatticeSlice<C, V>? {
        
        //TODO: change Triangle param to Vertex?
        guard let region = grid.region(for: triangle.transpose(.region,
                                                               .tile)) else { return nil }
        
        return .init(dataStore: dataStore.chunks(intersecting: triangle),
                     region: region)
    }
}
