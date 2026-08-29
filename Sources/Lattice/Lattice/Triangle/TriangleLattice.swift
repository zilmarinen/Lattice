//
//  TriangleLattice.swift
//  Lattice
//
//  Created by Zack Brown on 28/08/2026.
//

import Deltille
import SpriteKit

public class TriangleLattice<C: TriangularChunk,
                             V: DataStoreValue>: SKNode,
                                                 Lattice where V.C == Triangle {

    internal let dataStore = TriangleDataStore<V>()
    
    public let grid = TriangularGrid<TriangularRegion<C>, C>()
    
    required override public init() {
        
        super.init()
        
        addChild(dataStore)
        addChild(grid)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

public extension TriangleLattice {
    
    func remove(_ keys: Set<V.C>) {
        
        dataStore.remove(keys)
        
        grid.propagate(keys)
    }
    
    func set(_ value: V) {
        
        dataStore.set(value)
        
        grid.propagate(value.footprint,
                       true)
    }
    
    func value(for key: V.C) -> V? {
     
        dataStore.value(for: key)
    }
}
