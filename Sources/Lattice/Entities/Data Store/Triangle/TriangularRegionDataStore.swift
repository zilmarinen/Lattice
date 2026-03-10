//
//  TriangularRegionDataStore.swift
//  Lattice
//
//  Created by Zack Brown on 07/03/2026.
//

import Deltille
import RealityKit

internal class TriangularRegionDataStore<C: TriangularChunkDataStore<V>,
                                         V: HasFootprint>: TriangularRegion<C>,
                                                           RegionDataStore {
    
    internal func merge(_ chunk: C) {
        
        let match = chunk.triangle.transpose(.chunk,
                                             .tile)
        
        guard let existing = self.chunk(for: match) else {
            
            return addChild(chunk)
        }
        
        existing.merge(chunk.store)
    }
    
    internal func value(for key: Triangle.Vertex) -> V? {
        
        let triangle = Triangle(key.position(.tile),
                                .chunk)
        
        guard let chunk = chunk(for: triangle) else { return nil }
        
        return chunk.value(for: key)
    }
    
    internal func set(_ value: V?,
                      for key: Triangle.Vertex) {
        
        let triangle = Triangle(key.position(.tile),
                                .chunk)
        
        let chunk = chunk(for: triangle) ?? C(triangle)
        
        if chunk.parent == nil {
            
            addChild(chunk)
        }
        
        chunk.set(value,
                  for: key)
        
        becomeDirty()
        
        guard chunk.isEmpty else { return }
        
        chunk.removeFromParent()
    }
}
