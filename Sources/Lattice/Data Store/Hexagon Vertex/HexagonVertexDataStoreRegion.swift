//
//  HexagonVertexDataStoreRegion.swift
//  Lattice
//
//  Created by Zack Brown on 28/08/2026.
//

import Deltille
import SpriteKit

internal class HexagonVertexDataStoreRegion<C: DataStoreChunk<Triangle, V>,
                                            V: DataStoreValue>: DataStoreNode<Triangle> where V.C == Hexagon.Vertex {
    
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

internal extension HexagonVertexDataStoreRegion {
    
    var chunks: [C] {
        
        children.compactMap {
            
            $0 as? C
        }
    }
    
    var isEmpty: Bool {
        
        children.isEmpty
    }
}

internal extension HexagonVertexDataStoreRegion {
 
    func chunk(for triangle: Triangle,
               _ from: Scale) -> C? {
        
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
