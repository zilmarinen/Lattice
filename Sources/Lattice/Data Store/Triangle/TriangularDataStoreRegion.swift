//
//  TriangularDataStoreRegion.swift
//  Lattice
//
//  Created by Zack Brown on 22/08/2026.
//

import Deltille
import SpriteKit

internal class TriangularDataStoreRegion<C: DataStoreChunk<Triangle, Triangle.Scale, V>,
                                         V: DataStoreValue>: DataStoreNode<Triangle, Triangle.Scale> where V.C == Triangle {
    
    required public init(_ tile: Triangle) {
        
        super.init(tile,
                   .region)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    required public init(from decoder: any Decoder) throws {
         
        try super.init(from: decoder)
    }
}

internal extension TriangularDataStoreRegion {
    
    var chunks: [C] {
        
        children.compactMap {
            
            $0 as? C
        }
    }
}

internal extension TriangularDataStoreRegion {
 
    func chunk(for triangle: Triangle,
               _ from: Triangle.Scale) -> C? {
        
        let chunk = triangle.transpose(from,
                                       .chunk)
        
        return chunks.first {
            
            $0.tile == chunk
        }
    }
    
    func chunks(intersecting region: Triangle) -> [C] {
        
        chunks.filter {
            
            $0.tile.transpose(.chunk,
                              .region) == region
        }
    }
}
