//
//  HexagonGrid.swift
//  Lattice
//
//  Created by Zack Brown on 18/08/2026.
//

import Deltille
import SpriteKit

public class HexagonGrid<C: HexagonChunk>: SKNode {}

internal extension HexagonGrid {

    var chunks: [C] {
        
        children.compactMap {
            
            $0 as? C
        }
    }
}

internal extension HexagonGrid {
    
    func chunk(for hexagon: Hexagon,
               _ from: Hexagon.Scale) -> C? {
        
        let chunk = hexagon.transpose(from,
                                      .chunk)
        
        return chunks.first {
            
            $0.hexagon == chunk
        }
    }
    
    func chunks(intersecting hexagon: Hexagon,
                _ from: Hexagon.Scale) -> [C] {
        
        let chunk = hexagon.transpose(from,
                                      .chunk)
        
        return chunks.filter {
            
            $0.hexagon == chunk
        }
    }
}

//TODO: REMOVE
public class ExampleHexagonGrid: HexagonGrid<ExampleHexagonChunk> {
    
}
