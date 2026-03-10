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
    
    typealias R = HexagonalRegionDataStore<HexagonalChunkDataStore<V>, V>
    
    internal let dataSource = HexagonalGridDataStore<R, HexagonalChunkDataStore<V>, V>()
    
    public let grid = TriangularGrid<TriangularRegion<C>, C>()
    
    public required init() {
        
        super.init()
        
        addChild(dataSource)
        addChild(grid)
    }
}

public extension HexagonalLattice {
    
    func set(_ value: V?,
                    for key: Triangle.Vertex) {
        
        dataSource.set(value,
                       for: key)
        
        grid.propagate(vertex: key)
    }
    
    func value(for key: Triangle.Vertex) -> V? {
        
        dataSource.value(for: key)
    }
    
    func remove(values keys: [Triangle.Vertex]) {
        
        dataSource.remove(values: keys)
    }
    
    func slice(for sieve: Triangle.Sieve) -> HexagonalDataStoreSlice<V> {
    
        dataSource.slice(for: sieve)
    }
}

extension HexagonalLattice {
    
    //TODO: Merge into Lattice protocol?
    public func merge(_ slice: HexagonalLatticeSlice<C, V>) {
        
        dataSource.merge(slice.dataSource)
        grid.merge(slice.region)
    }
    
    //TODO: Merge into Lattice protocol?
    public func slice(region triangle: Triangle) -> HexagonalLatticeSlice<C, V>? {
        
        //TODO: change Triangle param to Vertex?
        guard let region = grid.region(for: triangle.transpose(.region,
                                                               .tile)) else { return nil }
        
        return .init(dataSource: dataSource.chunks(intersecting: triangle),
                     region: region)
    }
}
