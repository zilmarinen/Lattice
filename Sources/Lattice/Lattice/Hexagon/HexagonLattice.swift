//
//  HexagonLattice.swift
//  Lattice
//
//  Created by Zack Brown on 28/08/2026.
//

import Deltille
import SpriteKit

public class HexagonLattice<C: GridChunk<Hexagon>,
                            V: DataStoreValue>: SKNode,
                                                Lattice where V.C == Hexagon {
    
    public typealias R = GridRegion<C, T>
    public typealias T = Hexagon
    
    public let grid = Grid<R, C, T>()
    
    public let store = HexagonDataStore<V>()
    
    required override public init() {
        
        super.init()
        
        addChild(grid)
        addChild(store)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

public extension HexagonLattice {
    
    func remove(_ keys: Set<V.C>) {
        
        store.remove(keys)
        
        grid.propagate(keys)
    }
    
    func set(_ value: V) {
        
        store.set(value)
        
        grid.propagate(value.footprint,
                       true)
    }
    
    func value(for key: V.C) -> V? {
     
        store.value(for: key)
    }
}
