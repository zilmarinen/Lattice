//
//  HexagonalGrid.swift
//  Lattice
//
//  Created by Zack Brown on 07/03/2026.
//

import Deltille
import RealityKit

open class HexagonalGrid<R: HexagonalRegion<C>,
                         C: HexagonalEntity>: Entity {
    
    internal func merge(_ region: R) {
        
        guard let existing = self.region(for: region.hexagon,
                                         .region) else {
            
            return addChild(region)
        }
        
        for chunk in region.chunks {
            
            guard existing.chunk(for: chunk.hexagon,
                                 .chunk) == nil else { continue }
            
            existing.addChild(chunk)
        }
    }
}

public extension HexagonalGrid {
    
    var descendants: [R] {
        
        regions
    }
    
    var regions: [R] {
        
        children.compactMap {
            
            $0 as? R
        }
    }
}

public extension HexagonalGrid {
    
    func region(for hexagon: Hexagon,
                _ from: Hexagon.Scale) -> R? {
        
        let region = hexagon.transpose(from,
                                       .region)
        
        return regions.first {
            
            $0.hexagon == region
        }
    }
    
    func chunk(for chunk: Hexagon,
               _ from: Hexagon.Scale) -> C? {
        
        guard let region = region(for: chunk,
                                  from) else { return nil }
        
        return region.chunk(for: chunk,
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
