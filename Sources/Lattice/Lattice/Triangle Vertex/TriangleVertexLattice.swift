//
//  TriangleVertexLattice.swift
//  Lattice
//
//  Created by Zack Brown on 28/08/2026.
//

import Deltille
import SpriteKit

public class TriangleVertexLattice<C: HexagonalChunk,
                                   V: DataStoreValue>: SKNode,
                                                       DataStore where V.C == Triangle.Vertex {
    
    internal let dataStore = TriangleVertexDataStore<V>()
    
    public let grid = HexagonalGrid<HexagonalRegion<C>, C>()
    
    required override public init() {
        
        super.init()
        
        addChild(dataStore)
        addChild(grid)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

public extension TriangleVertexLattice {
    
    func remove(_ keys: Set<V.C>) {
        
        dataStore.remove(keys)
    }
    
    func set(_ value: V) {
        
        dataStore.set(value)
    }
    
    func value(for key: V.C) -> V? {
     
        dataStore.value(for: key)
    }
}
