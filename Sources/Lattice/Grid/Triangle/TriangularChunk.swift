//
//  TriangularChunk.swift
//  Lattice
//
//  Created by Zack Brown on 28/08/2026.
//

import Deltille
import SpriteKit

public class TriangularChunk: SKShapeNode,
                              Soilable {
    
    internal(set) public var isDirty: Bool = false
    
    public let tile: Triangle
    
    public required init(tile: Triangle) {
        
        self.tile = tile
        
        super.init()
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
