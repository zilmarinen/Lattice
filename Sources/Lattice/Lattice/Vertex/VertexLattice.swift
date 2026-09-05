//
//  VertexLattice.swift
//  Lattice
//
//  Created by Zack Brown on 28/08/2026.
//

import Deltille
import SpriteKit

open class VertexLattice<C: GridChunk<T>,
                         T: Tile,
                         V: DataStoreValue>: SKNode,
                                             Lattice where V.C == T.D.V,
                                                           V.C == T.D.SI.V {

    public typealias R = GridRegion<C, T>
    
    public let grid: Grid<R, C, T>
    
    public let store: VertexDataStore<T, V>
    
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
