//
//  HexagonLattice.swift
//  Lattice
//
//  Created by Zack Brown on 18/08/2026.
//

import Deltille
import SpriteKit

public class HexagonLattice<C: HexagonChunk,
                            T: DataStoreTile>: SKNode,
                                               @preconcurrency Lattice where T.T == Hexagon {
    
    public let grid = HexagonGrid<C>()
    public let store = HexagonDataStore<T>()
    
    required override public init() {
        
        super.init()
        
        addChild(grid)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

public extension HexagonLattice {
    
    func remove(_ keys: [T.V]) {
        
        store.remove(keys)
    }
    
    func set(_ value: T) {
        
        store.set(value)
    }
    
    func value(for key: T.V) -> T? {
        
        store.value(for: key)
    }
}

//TODO: REMOVE
public class ExampleHexagonLattice: HexagonLattice<ExampleHexagonChunk, ExampleHexagonTile> {
    
}
