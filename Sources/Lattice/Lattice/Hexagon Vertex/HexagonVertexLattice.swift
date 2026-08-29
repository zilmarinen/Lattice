//
//  HexagonVertexLattice.swift
//  Lattice
//
//  Created by Zack Brown on 28/08/2026.
//

import Deltille
import SpriteKit

public class HexagonVertexLattice<C: TriangularChunk,
                                  V: DataStoreValue>: SKNode,
                                                      DataStore where V.C == Hexagon.Vertex {

    internal let dataStore = HexagonVertexDataStore<V>()
    
    public let grid = TriangularGrid<TriangularRegion<C>, C>()
    
    required override public init() {
        
        super.init()
        
        addChild(dataStore)
        addChild(grid)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

public extension HexagonVertexLattice {
    
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
