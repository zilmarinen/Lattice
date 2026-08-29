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
                              _ scale: Scale) -> CGPath {
        
        let path = CGMutablePath()
        
        let vertices = tile.vertices(scale)
        
        guard let last = vertices.last else { return path }
        
        let origin = tile.vertex
        
        path.move(to: .init(origin - last))
        
        for vertex in vertices {
            
            path.addLine(to: .init(origin - vertex))
        }
        
        return path
    }
}
