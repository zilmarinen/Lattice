//
//  VertexLattice.swift
//  Lattice
//
//  Created by Zack Brown on 28/08/2026.
//

import Deltille
import SpriteKit

public class VertexLattice<C: GridChunk<T>,
                           T: Tile,
                           V: DataStoreValue>: SKNode,
                                               Lattice where V.C == T.D.V {

    public typealias R = GridRegion<C, T>
    
    public let grid = Grid<R, C, T>()
    
    public let store = VertexDataStore<T, V>()
    
    required override public init() {
        
        super.init()
        
        addChild(grid)
        addChild(store)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
