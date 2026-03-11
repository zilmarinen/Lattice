//
//  TriangularDataStore.swift
//  Lattice
//
//  Created by Zack Brown on 07/03/2026.
//

import Deltille
import RealityKit

public class TriangularDataStore<R: TriangularDataStoreRegion<C, V>,
                                 C: TriangularDataStoreChunk<V>,
                                 V: TriangularDataStoreTile>: TriangularGrid<R, C>,
                                                              DataStore {
    
    public func merge(_ chunks: [C]) {
        
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
    
    public func value(for key: Triangle.Vertex) -> V? {
        
        guard let region = region(for: .init(key)) else { return nil }
        
        return region.value(for: key)
    }
    
    public func set(_ value: V?,
                    for key: Triangle.Vertex) {
        
        let triangle = Triangle(key)
        
        let region = region(for: triangle) ?? R(triangle.transpose(.tile,
                                                                   .region))
        
        if region.parent == nil {
            
            addChild(region)
        }
        
        region.set(value,
                   for: key)
        
        guard region.isEmpty else { return }
        
        region.removeFromParent()
    }
    
    public func wedge(for sieve: Triangle.Sieve) -> TriangularDataStoreWedge<V> {
        
        let tiles = sieve.tiles.reduce(into: [Triangle.Vertex : V]()) { result, tile in
            
            result[tile.vertex] = value(for: tile.vertex)
        }
        
        return .init(tiles: tiles)
    }
}
