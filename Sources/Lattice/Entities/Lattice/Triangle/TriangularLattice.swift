//
//  TriangularLattice.swift
//  Lattice
//
//  Created by Zack Brown on 10/03/2026.
//

import Deltille
import RealityKit

open class TriangularLattice<C: TriangularChunk,
                             V: TriangularDataStoreTile>: Entity,
                                                          Lattice {
    
    public typealias R = TriangularDataStoreRegion<TriangularDataStoreChunk<V>, V>
    
    public let dataStore = TriangularDataStore<R, TriangularDataStoreChunk<V>, V>()
    
    public let grid = TriangularGrid<TriangularRegion<C>, C>()
    
    public required init() {
        
        super.init()
        
        addChild(dataStore)
        addChild(grid)
    }
}

public extension TriangularLattice {
    
    func set(_ value: V,
             for key: Triangle) {
        
        dataStore.set(value,
                      for: key)
        
        key.vertices.forEach {
            
            grid.propagate(vertex: $0,
                           true)
        }
    }
    
    func remove(values keys: [Triangle]) {
        
        dataStore.remove(values: keys)
        
        keys.forEach {
            
            grid.propagate(triangle: $0)
        }
    }

    func merge(_ slice: TriangularLatticeSlice<C, V>) {
        
        dataStore.merge(slice.dataStore)
        grid.merge(slice.region)
    }
    
    func slice(region triangle: Triangle) -> TriangularLatticeSlice<C, V>? {
        
        guard let region = grid.region(for: triangle,
                                       .tile) else { return nil }
        
        return .init(dataStore: dataStore.chunks(intersecting: triangle,
                                                 .tile),
                     region: region)
    }
}
