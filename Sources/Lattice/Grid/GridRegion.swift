//
//  GridRegion.swift
//  Lattice
//
//  Created by Zack Brown on 31/08/2026.
//

import Deltille
import SpriteKit

public class GridRegion<C: GridChunk<T>,
                        T: Tile>: SKNode,
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

internal extension GridRegion {
    
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

internal extension GridRegion {
    
    func chunk(for tile: T,
               _ from: Scale) -> C? {
        
        let chunk = tile.transpose(from,
                                   .chunk)
        
        return chunks.first {
            
            $0.tile == chunk
        }
    }
}
