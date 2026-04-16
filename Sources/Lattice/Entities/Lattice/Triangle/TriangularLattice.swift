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
    
    private func set(_ value: V?,
                     for key: Triangle) {
        
        dataStore.set(value,
                      for: key.vertex)
        
        key.perimeter.forEach {
            
            grid.propagate(triangle: $0)
        }
    }
    
    func set(_ value: V?,
             for key: Triangle.Vertex) {
        
        guard let value else {
                    
            guard let existing = self.value(for: key) else { return }
            
            return existing.footprint.tiles.forEach {
                
                set(nil,
                    for: $0)
            }
        }
        
        for tile in value.footprint.tiles {
            
            guard self.value(for: tile.vertex) == nil else { return }
        }
        
        for tile in value.footprint.tiles {
            
            set(value,
                for: tile)
        }
    }
    
    func remove(values keys: [Triangle.Vertex]) {
        
        dataStore.remove(values: keys)
        
        keys.forEach {
            
            grid.propagate(triangle: .init($0))
        }
    }

    func merge(_ slice: TriangularLatticeSlice<C, V>) {
        
        dataStore.merge(slice.dataStore)
        grid.merge(slice.region)
    }
    
    func slice(region triangle: Triangle) -> TriangularLatticeSlice<C, V>? {
        
        guard let region = grid.region(for: triangle.transpose(.region,
                                                               .tile)) else { return nil }
        
        return .init(dataStore: dataStore.chunks(intersecting: triangle),
                     region: region)
    }
}
