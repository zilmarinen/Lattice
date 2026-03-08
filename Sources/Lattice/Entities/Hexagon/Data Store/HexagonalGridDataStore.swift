//
//  HexagonalGridDataStore.swift
//  Lattice
//
//  Created by Zack Brown on 08/03/2026.
//

import Deltille
import RealityKit

internal class HexagonalGridDataStore<R: HexagonalRegionDataStore<C, V>,
                                      C: HexagonalChunkDataStore<V>,
                                      V: Codable>: HexagonalGrid<R, C>,
                                                   GridDataStore {
    
    internal func merge(_ chunks: [C]) {
        
        chunks.forEach {
            
            let match = $0.hexagon.parent()
            
            let region = region(for: match) ?? R(match)
            
            if region.parent == nil {
                
                addChild(region)
            }
            
            region.merge($0)
        }
    }
    
    internal func value(for key: Triangle.Vertex) -> V? {
        
        let hexagon = Hexagon(key.position(.tile),
                              .chunk)
        
        guard let region = region(for: hexagon.parent()) else { return nil }
        
        return region.value(for: key)
    }
    
    internal func set(_ value: V?,
                      for key: Triangle.Vertex) {
        
        let hexagon = Hexagon(key.position(.tile),
                              .chunk)
        
        let parent = hexagon.parent()
        
        let region = region(for: parent) ?? R(parent)
        
        if region.parent == nil {
            
            addChild(region)
        }
        
        region.set(value,
                   for: key)
        
        guard region.isEmpty else { return }
        
        region.removeFromParent()
    }
    
    internal func slice(for sieve: Triangle.Sieve) -> HexagonalDataStoreSlice<V> {
        
        let vertices = sieve.vertices.reduce(into: [Triangle.Vertex : V]()) { result, vertex in
            
            result[vertex] = value(for: vertex)
        }
        
        return .init(sieve: sieve,
                     vertices: vertices)
    }
}
