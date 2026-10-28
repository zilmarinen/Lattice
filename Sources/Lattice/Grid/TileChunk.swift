//
//  TileChunk.swift
//  Lattice
//
//  Created by Zack Brown on 31/08/2026.
//

import Deltille
import SpriteKit

open class TileChunk<T: Tile>: SKShapeNode,
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

private extension TileChunk {
    
    func update() {
        
        name = tile.id
        path = CGPath.tile(tile,
                           .chunk,
                           lattice)
        
        lineWidth = 2.0
        fillColor = .systemPink
        
        let region = tile.transpose(.chunk,
                                    .region)
        
        let origin = region.transpose(.region,
                                      .tile)
        
        let offset = tile.transpose(.chunk,
                                    .tile)
        
        position = .init((offset - origin).vertex,
                         lattice)
    }
}
