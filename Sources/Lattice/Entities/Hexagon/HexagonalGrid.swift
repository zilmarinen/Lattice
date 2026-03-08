//
//  HexagonalGrid.swift
//  Lattice
//
//  Created by Zack Brown on 07/03/2026.
//

import Deltille
import RealityKit

public class HexagonalGrid<R: HexagonalRegion<C>,
                           C: HexagonalEntity>: Entity {}

extension HexagonalGrid {
    
    internal var isEmpty: Bool {
        
        regions.isEmpty
    }
    
    internal var regions: [R] {
        
        children.compactMap {
            
            $0 as? R
        }
    }
}

extension HexagonalGrid {
    
    internal func region(for region: Hexagon) -> R? {
        
        regions.first {
            
            $0.hexagon == region
        }
    }
    
    internal func chunk(for chunk: Hexagon) -> C? {
        
        guard let region = region(for: chunk.parent()) else { return nil }
        
        return region.chunk(for: chunk)
    }
    
    internal func chunks(intersecting triangle: Triangle) -> [C] {
        
        regions.flatMap {
         
            $0.chunks(intersecting: triangle)
        }
    }
}
