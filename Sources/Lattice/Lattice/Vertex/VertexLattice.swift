//
//  VertexLattice.swift
//  Lattice
//
//  Created by Zack Brown on 28/08/2026.
//

import Deltille
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
}

public extension VertexLattice {
    
    func chunks(intersecting tile: G.T) -> [C] {
        
        []
    }
    
    func propagate(_ keys: Set<V.K>,
                   _ insertion: Bool = false) {
    
        let tiles = keys.flatMap {
            
            $0.tiles
        }
        
        let chunks = tiles.unique(.tile,
                                  .chunk)
        
        grid.propagate(chunks,
                       insertion)
    }
    
    func slice(for tile: G.T) -> LatticeSlice<G.C, G.T.D, G.T, V>? {
        
        guard let region = grid.region(for: tile,
                                       .region) else { return nil }
        
        let chunks = chunks(intersecting: tile)
        return nil
//        return .init(chunks: chunks,
//                     region: region)
    }
    
    func wedge(for sieve: V.T.D.SI) -> DataStoreWedge<V.K, V> {
        
        let data = sieve.vertices.reduce(into: [V.K : V]()) { result, vertex in
                    
            result[vertex] = value(for: vertex)
        }
        
        return .init(data: data)
    }
}
