//
//  TriangularGrid.swift
//  Lattice
//
//  Created by Zack Brown on 07/03/2026.
//

import Deltille
import RealityKit

public class TriangularGrid<R: TriangularRegion<C>,
                            C: TriangularEntity>: Entity,
                                                  DefinesHierarchy {
    
    internal func merge(_ region: R) {
        
        guard let existing = self.region(for: region.triangle,
                                         .region) else {
            
            return addChild(region)
        }
        
        for chunk in region.chunks {
            
            guard existing.chunk(for: chunk.triangle,
                                 .chunk) == nil else { continue }
            
            existing.addChild(chunk)
        }
    }
}

public extension TriangularGrid {
    
    var descendants: [R] {
        
        regions
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

public extension TriangularGrid {
    
    func propagate(triangle: Triangle,
                   _ createHierarchy: Bool = false) {
        
        guard createHierarchy else {
            
            guard let region = region(for: triangle,
                                      .tile),
                  let chunk = region.chunk(for: triangle,
                                           .tile) else { return }
            
            chunk.becomeDirty()
            
            return region.becomeDirty()
        }
        
        let region = region(for: triangle,
                            .tile) ?? .init(triangle.transpose(.tile,
                                                               .region))
        
        let chunk = region.chunk(for: triangle,
                                 .tile) ?? .init(triangle.transpose(.tile,
                                                                    .chunk))
        
        if chunk.parent == nil {
            
            region.addChild(chunk)
        }
        
        chunk.becomeDirty()
        
        if region.parent == nil {
            
            addChild(region)
        }
        
        region.becomeDirty()
    }
    
    func propagate(vertex: Triangle.Vertex,
                   _ createHierarchy: Bool = false) {
        
        let unique = vertex.tiles.unique(.tile,
                                         .chunk)
        
        let tiles = vertex.tiles.filter {
            
            let chunk = $0.transpose(.tile,
                                     .chunk)
            
            return unique.contains(chunk)
        }
        
        for triangle in tiles {
            
            propagate(triangle: triangle,
                      createHierarchy)
        }
    }
}
