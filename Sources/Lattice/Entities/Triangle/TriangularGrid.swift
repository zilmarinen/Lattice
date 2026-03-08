//
//  TriangularGrid.swift
//  Lattice
//
//  Created by Zack Brown on 07/03/2026.
//

import Deltille
import RealityKit

public class TriangularGrid<R: TriangularRegion<C>,
                            C: TriangularEntity>: Entity {
    
    internal func merge(_ region: R) {
        
        let match = region.triangle.transpose(.region,
                                              .tile)
        
        guard let existing = self.region(for: match) else {
            
            return addChild(region)
        }
        
        for chunk in region.chunks {
            
            guard existing.chunk(for: chunk.triangle) == nil else { continue }
            
            existing.addChild(chunk)
        }
    }
}

public extension TriangularGrid {
    
    var isEmpty: Bool {
        
        regions.isEmpty
    }
    
    var regions: [R] {
        
        children.compactMap {
            
            $0 as? R
        }
    }
    
    var dirtyRegions: [R] {
        
        regions.filter {
            
            $0.isDirty
        }
    }
}

public extension TriangularGrid {
    
    func region(for tile: Triangle) -> R? {
        
        let region = tile.transpose(.tile,
                                    .region)
        
        return regions.first {
            
            $0.triangle == region
        }
    }
    
    func chunk(for tile: Triangle) -> C? {
        
        guard let region = region(for: tile) else { return nil }
        
        return region.chunk(for: tile)
    }
    
    func chunks(intersecting region: Triangle) -> [C] {
        
        regions.flatMap {
            
            $0.chunks(intersecting: region)
        }
    }
}

internal extension TriangularGrid {
    
    func propagate(triangle tile: Triangle) {
        
        let region = region(for: tile) ?? .init(tile.transpose(.tile,
                                                               .region))
        
        if region.parent == nil {
            
            addChild(region)
        }
        
        region.propagate(triangle: tile)
    }
    
    func propagate(vertex: Triangle.Vertex) {
        
        for triangle in vertex.tiles {
            
            propagate(triangle: triangle)
        }
    }
}
