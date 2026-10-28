//
//  TileLattice.swift
//  Lattice
//
//  Created by Zack Brown on 28/08/2026.
//

import Deltille
import SpriteKit

open class TileLattice<C: TileChunk<V.T>,
                       V: DataStoreValue>: SKNode,
                                           Lattice where V.K == V.T,
                                                         V.K == V.K.SI.T {
    
    public let grid: TileGrid<C, V.T>
    public let store: TileDataStore<V>
    
    required public init(_ lattice: Double = 1.0) {
        
        self.grid = .init(lattice)
        self.store = .init(lattice)
        
        super.init()
        
        addChild(grid)
        addChild(store)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

public extension TileLattice {
    
    func propagate(_ keys: Set<V.K>,
                   _ insertion: Bool = false) {
        
        let chunks = keys.unique(.tile,
                                 .chunk)
        
        grid.propagate(chunks,
                       insertion)
    }
}
