//
//  TriangularDataStore.swift
//  Lattice
//
//  Created by Zack Brown on 07/03/2026.
//

import Deltille
import RealityKit

public class TriangularDataStoreRegion<C: TriangularDataStoreChunk<V>,
                                       V: TriangularDataStoreTile>: TriangularRegion<C>,
                                                                    DataStoreRegion {
    
    public func merge(_ chunk: C) {
        
        let match = chunk.triangle.transpose(.chunk,
                                             .tile)
        
        guard let existing = self.chunk(for: match) else {
            
            return addChild(chunk)
        }
        
        existing.merge(chunk.store)
    }
    
    public func value(for key: Triangle.Vertex) -> V? {
        
        guard let chunk = chunk(for: .init(key)) else { return nil }
        
        return chunk.value(for: key)
    }
    
    public func set(_ value: V?,
                    for key: Triangle.Vertex) {
        
        let triangle = Triangle(key)
        
        let chunk = chunk(for: triangle) ?? C(triangle.transpose(.tile,
                                                                 .chunk))
        
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
