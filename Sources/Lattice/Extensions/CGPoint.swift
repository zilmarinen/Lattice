//
//  CGPoint.swift
//  Lattice
//
//  Created by Zack Brown on 28/08/2026.
//

import CoreGraphics
import Deltille

public extension CGPoint {
    
    init(_ vertex: any Vertex) {
        
        let vector = vertex.vector
        
        self.init(x: vector.x,
                  y: vector.z)
    }
}
