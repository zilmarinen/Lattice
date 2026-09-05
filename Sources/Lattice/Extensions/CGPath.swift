//
//  CGPath.swift
//  Lattice
//
//  Created by Zack Brown on 28/08/2026.
//

import CoreGraphics
import Deltille
import Euclid

public extension CGPath {
    
    static func tile<T: Tile>(_ tile: T,
                              _ scale: Scale,
                              _ lattice: Double = 1.0) -> CGPath {
        
        let path = CGMutablePath()
        
        let vertices = tile.vertices(scale).map {
            
            $0.vector(lattice)
        }
        
        guard let last = vertices.last else { return path }
        
        let origin = tile.transpose(scale,
                                    .tile).vertex.vector(lattice)
        
        path.move(to: .init(x: last.x - origin.x,
                            y: last.z - origin.z))
        
        for vertex in vertices {
            
            path.addLine(to: .init(x: vertex.x - origin.x,
                                   y: vertex.z - origin.z))
        }
        
        return path
    }
}
