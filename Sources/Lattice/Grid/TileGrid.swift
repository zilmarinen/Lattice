//
//  TileGrid.swift
//  Lattice
//
//  Created by Zack Brown on 31/08/2026.
//

import Deltille
import SpriteKit

public class TileGrid<C: TileChunk<T>,
                      T: Tile>: SKNode,
                                Grid {
    
    public typealias R = TileRegion<C, T>
    
    public let lattice: Double
    
    required public init(_ lattice: Double) {
        
        self.lattice = lattice
        
        super.init()
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
