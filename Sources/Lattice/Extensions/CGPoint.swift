//
//  CGPoint.swift
//  Lattice
//
//  Created by Zack Brown on 28/08/2026.
//

import CoreGraphics
import Deltille

public extension CGPoint {
    
    init(_ vertex: any Vertex,
         _ lattice: Double = 1.0) {
        
        let vector = vertex.vector(lattice)
        
        self.init(x: vector.x,
                  y: vector.z)
    }
}
