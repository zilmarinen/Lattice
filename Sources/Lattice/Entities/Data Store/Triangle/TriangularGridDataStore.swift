//
//  TriangularGridDataStore.swift
//  Lattice
//
//  Created by Zack Brown on 07/03/2026.
//

import Deltille
import RealityKit

internal class TriangularGridDataStore<R: TriangularRegionDataStore<C, V>,
                                       C: TriangularChunkDataStore<V>,
                                       V: HasFootprint>: TriangularGrid<R, C>,
                                                         GridDataStore {
    
    internal func merge(_ chunks: [C]) {
        
        chunks.forEach {
            
            let match = $0.triangle.transpose(.chunk,
                                              .tile)
            
            let region = region(for: match) ?? R($0.triangle.transpose(.chunk,
                                                                       .region))
            
            if region.parent == nil {
                
                addChild(region)
            }
            
            region.merge($0)
        }
    }
    
    internal func value(for key: Triangle.Vertex) -> V? {
        
        let triangle = Triangle(key.position(.tile),
                                .chunk)
        
        guard let region = region(for: triangle) else { return nil }
        
        return region.value(for: key)
    }
    
    internal func set(_ value: V?,
                      for key: Triangle.Vertex) {
        
        let triangle = Triangle(key.position(.tile),
                                .chunk)
        
        let region = region(for: triangle) ?? R(triangle)
        
        if region.parent == nil {
            
            addChild(region)
        }
        
        region.set(value,
                   for: key)
        
        guard region.isEmpty else { return }
        
        region.removeFromParent()
    }
    
    internal func slice(for sieve: Triangle.Sieve) -> TriangularDataStoreSlice<V> {
        
        let tiles = sieve.tiles.reduce(into: [Triangle.Vertex : V]()) { result, tile in
            
            result[tile.vertex] = value(for: tile.vertex)
        }
        
        return .init(tiles: tiles)
    }
}
