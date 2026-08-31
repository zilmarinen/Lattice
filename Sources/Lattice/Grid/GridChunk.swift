//
//  GridChunk.swift
//  Lattice
//
//  Created by Zack Brown on 31/08/2026.
//

import Deltille
import SpriteKit

public class GridChunk<T: Tile>: SKShapeNode,
                                 Soilable {
       
    internal(set) public var isDirty: Bool = false

    public let tile: T

    public required init(tile: T) {

        self.tile = tile

        super.init()
    }

    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
