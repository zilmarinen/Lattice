//
//  DataStoreRegion.swift
//  Lattice
//
//  Created by Zack Brown on 22/08/2026.
//

import Deltille
import SpriteKit

internal class DataStoreRegion<C: DataStoreChunk<T, V>,
                               T: Tile,
                               V: DataStoreValue>: DataStoreNode<T> {
    
    required internal init(_ tile: T) {
        
        super.init(tile,
                   .region)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    required public init(from decoder: any Decoder) throws {
         
        try super.init(from: decoder)
    }
}

internal extension DataStoreRegion {
    
    var chunks: [C] {
        
        children.compactMap {
            
            $0 as? C
        }
    }
    
    var isEmpty: Bool {
        
        children.isEmpty
    }
}

internal extension DataStoreRegion {
 
    func chunk(for tile: T,
               _ from: Scale) -> C? {
        
        let chunk = tile.transpose(from,
                                   .chunk)
        
        return chunks.first {
            
            $0.tile == chunk
        }
    }
}
