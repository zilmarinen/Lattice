//
//  TriangularLattice.swift
//  Lattice
//
//  Created by Zack Brown on 10/03/2026.
//

import Deltille
import RealityKit

open class TriangularLattice<C: TriangularChunk,
                             V: HasFootprint>: Entity,
                                               Lattice {
    
    typealias R = TriangularRegionDataStore<TriangularChunkDataStore<V>, V>
    
    internal let dataSource = TriangularGridDataStore<R, TriangularChunkDataStore<V>, V>()
    
    public let grid = TriangularGrid<TriangularRegion<C>, C>()
    
    public required init() {
        
        super.init()
        
        addChild(dataSource)
        addChild(grid)
    }
}

public extension TriangularLattice {
    
    func set(_ value: V?,
                    for key: Triangle.Vertex) {
        
        func set(_ value: V?,
                 for tile: Triangle) {
            
            dataSource.set(value,
                           for: tile.vertex)
            
            grid.propagate(triangle: tile)
        }
        
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
     
        dataSource.remove(values: keys)
    }
    
    func value(for key: Triangle.Vertex) -> V? {
        
        dataSource.value(for: key)
    }
    
    func slice(for sieve: Triangle.Sieve) -> TriangularDataStoreSlice<V> {
    
        dataSource.slice(for: sieve)
    }
}

extension TriangularLattice {
    
    //TODO: Merge into Lattice protocol?
    public func merge(_ slice: TriangularLatticeSlice<C, V>) {
        
        dataSource.merge(slice.dataSource)
        grid.merge(slice.region)
    }
    
    //TODO: Merge into Lattice protocol?
    public func slice(region triangle: Triangle) -> TriangularLatticeSlice<C, V>? {
        
        //TODO: change Triangle param to Vertex?
        guard let region = grid.region(for: triangle.transpose(.region,
                                                               .tile)) else { return nil }
        
        return .init(dataSource: dataSource.chunks(intersecting: triangle),
                     region: region)
    }
}
