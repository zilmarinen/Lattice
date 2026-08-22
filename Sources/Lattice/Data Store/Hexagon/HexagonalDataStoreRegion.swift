//
//  HexagonalDataStoreRegion.swift
//  Lattice
//
//  Created by Zack Brown on 22/08/2026.
//

import Deltille
import SpriteKit

internal class HexagonalDataStoreRegion<C: DataStoreChunk<Hexagon, Hexagon.Scale, V>,
                                        V: DataStoreValue>: DataStoreNode<Hexagon, Hexagon.Scale> where V.C == Triangle.Vertex {
    
    required public init(_ tile: Hexagon) {
        
        super.init(tile,
                   .region)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    required public init(from decoder: any Decoder) throws {
         
        try super.init(from: decoder)
    }
}

internal extension HexagonalDataStoreRegion {
    
    var chunks: [C] {
        
        children.compactMap {
            
            $0 as? C
        }
    }
    
    var isEmpty: Bool {
        
        children.isEmpty
    }
}

internal extension HexagonalDataStoreRegion {
 
    func chunk(for hexagon: Hexagon,
               _ from: Hexagon.Scale) -> C? {
        
        let chunk = hexagon.transpose(from,
                                      .chunk)
        
        return chunks.first {
            
            $0.tile == chunk
        }
    }
    
    func chunks(intersecting region: Triangle) -> [C] {
        
        chunks.filter {
                    
            for vertex in $0.tile.vertices(.chunk) {
                
                let tile = Triangle(vertex.vector)
                
                let match = tile.transpose(.chunk,
                                           .region)
                
                if match == region {
                    
                    return true
                }
            }
            
            for vertex in region.vertices(.region) {
                
                let tile = Hexagon(vertex.vector)
                
                let match = tile.transpose(.region,
                                           .chunk)
                
                if match == $0.tile {
                    
                    return true
                }
            }
            
            return false
        }
    }
}
