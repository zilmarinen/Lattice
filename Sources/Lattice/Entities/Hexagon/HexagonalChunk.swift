//
//  HexagonalChunk.swift
//  Lattice
//
//  Created by Zack Brown on 23/05/2026.
//

import Deltille
import RealityKit

open class HexagonalChunk: HexagonalEntity {
    
    required public init(_ hexagon: Hexagon) {
        
        super.init(hexagon,
                   .chunk)
    }
    
    @available(*, unavailable)
    required public init() { fatalError("init() has not been implemented") }
    
    required public init(from decoder: any Decoder) throws {
        
        try super.init(from: decoder)
    }
}
