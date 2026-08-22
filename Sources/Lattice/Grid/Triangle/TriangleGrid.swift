//
//  TriangleGrid.swift
//  Lattice
//
//  Created by Zack Brown on 18/08/2026.
//

import Deltille
import SpriteKit

public class TriangleGrid<R: TriangleRegion<C>,
                          C: TriangleChunk>: SKNode {}

internal extension TriangleGrid {
    
    var regions: [R] {
        
        children.compactMap {
            
            $0 as? R
        }
    }
}

internal extension TriangleGrid {
    
    func region(for triangle: Triangle,
                _ from: Triangle.Scale) -> R? {
        
        let region = triangle.transpose(from,
                                        .region)
        
        return regions.first {
            
            $0.triangle == region
        }
    }
    
    func chunk(for triangle: Triangle,
               _ from: Triangle.Scale) -> C? {
        
        guard let region = self.region(for: triangle,
                                       from) else { return nil }
        
        return region.chunk(for: triangle,
                            from)
    }
    
    func chunks(intersecting triangle: Triangle,
                _ from: Triangle.Scale) -> [C] {
        
        regions.flatMap {
            
            $0.chunks(intersecting: triangle,
                      from)
        }
    }
}

//TODO: REMOVE
public class ExampleTriangleGrid: TriangleGrid<ExampleTriangleRegion, ExampleTriangleChunk> {
    
}
