//
//  GridChunk.swift
//  Lattice
//
//  Created by Zack Brown on 31/08/2026.
//

import Deltille
import SpriteKit

open class GridChunk<T: Tile>: SKShapeNode,
                               Soilable {
       
    internal(set) public var isDirty: Bool = false

    public let tile: T
    public let lattice: Double

    required public init(_ tile: T,
                         _ lattice: Double) {

        self.tile = tile
        self.lattice = lattice

        super.init()
        
        update()
    }

    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

private extension GridChunk {
    
    func update() {
        
        name = tile.id
        
        let region = tile.transpose(.chunk,
                                    .region)
        
        position = .init(tile.vertex - region.vertex,
                         lattice)
    }
}
