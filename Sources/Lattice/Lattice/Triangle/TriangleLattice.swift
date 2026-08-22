//
//  TriangleLattice.swift
//  Lattice
//
//  Created by Zack Brown on 18/08/2026.
//

import Deltille
import SpriteKit

public class TriangleLattice<C: TriangleChunk,
                             T: DataStoreTile>: SKNode,
                                                @preconcurrency Lattice where T.T == Triangle {
    
    public let grid = TriangleGrid<TriangleRegion<C>, C>()
    public let store = TriangleDataStore<T>()
    
    required override public init() {
        
        super.init()
        
        addChild(grid)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

public extension TriangleLattice {
    
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
public class ExampleTriangleLattice: TriangleLattice<ExampleTriangleChunk, ExampleTriangleTile> {
    
}
