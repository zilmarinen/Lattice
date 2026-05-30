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
        
        propagate([key],
                  true)
    }
    
    func remove(values keys: [Triangle]) {
        
        dataStore.remove(values: keys)
        
        propagate(keys)
    }
    
    func propagate(_ keys: [Triangle],
                   _ createHierarchy: Bool = false) {
        
        let triangles = Set(keys.flatMap {
            
            $0.perimeter
        })
        
        grid.propagate(Array(triangles),
                       createHierarchy)
    }

    func merge(_ slice: TriangularLatticeSlice<C, V>) {
        
        dataStore.merge(slice.stores)
        grid.merge(slice.region)
    }
    
    func slice(region triangle: Triangle) -> TriangularLatticeSlice<C, V>? {
        
        guard let region = grid.region(for: triangle,
                                       .region) else { return nil }
        
        return .init(stores: dataStore.chunks(intersecting: triangle,
                                              .region),
                     region: region)
    }
}
