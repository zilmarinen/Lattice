//
//  VertexLattice.swift
//  Lattice
//
//  Created by Zack Brown on 28/08/2026.
//

import Deltille
import Euclid
import SpriteKit

open class VertexLattice<C: TileChunk<V.T.D>,
                         V: DataStoreValue>: SKNode,
                                             Lattice where V.K == V.T.D.V,
                                                           V.K == V.T.D.SI.V,
                                                           V.K.T == V.T.D {

    public let grid: TileGrid<C, V.T.D>
    public let store: VertexDataStore<V>
    
    required public init(_ lattice: Double = 1.0) {
        
        self.grid = .init(lattice)
        self.store = .init(lattice)
        
        super.init()
        
        addChild(grid)
        addChild(store)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    open func clean(_ chunk: C,
                    _ sieve: V.T.D.SI,
                    _ wedge: DataStoreWedge<V.K, V>) -> Bool {
        
        fatalError("clean(chunk:sieve:wedge:) has not been implemented")
    }
}

public extension VertexLattice {
    
    func propagate(_ keys: Set<V.K>,
                   _ insertion: Bool = false) {
    
        let tiles = Set(keys.flatMap {
            
            $0.tiles.map { tile in
                
                V.K.T(tile.vertex.vector(store.lattice),
                      grid.lattice)
            }
        })
        
        let chunks = tiles.unique(.tile,
                                  .chunk)
        
        grid.propagate(chunks,
                       insertion)
    }
}
