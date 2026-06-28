//
//  HexagonalLattice.swift
//  Lattice
//
//  Created by Zack Brown on 10/03/2026.
//

import Deltille
import RealityKit

open class HexagonalLattice<C: TriangularChunk,
                            V: DataStoreValue>: Entity,
                                                Lattice {
    
    public typealias R = HexagonalDataStoreRegion<HexagonalDataStoreChunk<V>, V>
    
    public let dataStore = HexagonalDataStore<R, HexagonalDataStoreChunk<V>, V>()
    
    public let grid = TriangularGrid<TriangularRegion<C>, C>()
    
    required public init() {
        
        super.init()
        
        addChild(dataStore)
        addChild(grid)
    }
}

public extension HexagonalLattice {
    
    func set(_ value: V,
             for key: Triangle.Vertex) {
        
        dataStore.set(value,
                      for: key)
        
        propagate([key],
                  true)
    }
    
    func remove(values keys: [Triangle.Vertex]) {
        
        dataStore.remove(values: keys)
        
        propagate(keys)
    }
    
    func propagate(_ keys: [Triangle.Vertex],
                   _ createHierarchy: Bool = false) {
        
        let triangles = Set(keys.flatMap {
            
            $0.tiles
        })
        
        grid.propagate(Array(triangles),
                       createHierarchy)
    }

    func merge(_ slice: HexagonalLatticeSlice<C, V>) {
        
        dataStore.merge(slice.stores)
        grid.merge(slice.region)
    }
    
    func slice(region triangle: Triangle) -> HexagonalLatticeSlice<C, V>? {
        
        guard let region = grid.region(for: triangle,
                                       .region) else { return nil }
        
        return .init(stores: dataStore.chunks(intersecting: triangle,
                                              .region),
                     region: region)
    }
}
