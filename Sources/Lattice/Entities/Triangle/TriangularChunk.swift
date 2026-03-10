//
//  TriangularChunk.swift
//  Lattice
//
//  Created by Zack Brown on 07/03/2026.
//

import Deltille
import RealityKit

open class TriangularChunk: TriangularEntity,
                            HasSoilableComponent {
    
    required public init(_ triangle: Triangle) {
        
        super.init(triangle,
                   .chunk)
    }
    
    @available(*, unavailable)
    required public init() { fatalError("init() has not been implemented") }
    
    required public init(from decoder: any Decoder) throws {
        
        try super.init(from: decoder)
    }
}
