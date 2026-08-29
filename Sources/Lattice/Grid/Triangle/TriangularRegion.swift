//
//  TriangularRegion.swift
//  Lattice
//
//  Created by Zack Brown on 28/08/2026.
//

import Deltille
import SpriteKit

public class TriangularRegion<C: TriangularChunk>: SKNode,
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

internal extension TriangularRegion {
    
    var chunks: [C] {
        
        children.compactMap {
            
            $0 as? C
        }
    }
    
    var dirtyChunks: [C] {
        
        chunks.filter {
            
            $0.isDirty
        }
    }
    
    var isEmpty: Bool {
        
        children.isEmpty
    }
}

internal extension TriangularRegion {
 
    func chunk(for triangle: Triangle,
               _ from: Scale) -> C? {
        
        let chunk = triangle.transpose(from,
                                       .chunk)
        
        return chunks.first {
            
            $0.tile == chunk
        }
    }
}
