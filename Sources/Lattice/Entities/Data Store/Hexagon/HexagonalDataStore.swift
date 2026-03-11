//
//  HexagonalDataStore.swift
//  Lattice
//
//  Created by Zack Brown on 08/03/2026.
//

import Deltille
import RealityKit

public class HexagonalDataStore<R: HexagonalDataStoreRegion<C, V>,
                                C: HexagonalDataStoreChunk<V>,
                                V: Codable>: HexagonalGrid<R, C>,
                                             DataStore {
    
    public func merge(_ chunks: [C]) {
        
        chunks.forEach {
            
            let match = $0.hexagon.parent()
            
            let region = region(for: match) ?? R(match)
            
            if region.parent == nil {
                
                addChild(region)
            }
            
            region.merge($0)
        }
    }
    
    public func value(for key: Triangle.Vertex) -> V? {
        
        let hexagon = Hexagon(key.position(.tile),
                              .chunk)
        
        guard let region = region(for: hexagon.parent()) else { return nil }
        
        return region.value(for: key)
    }
    
    public func set(_ value: V?,
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
    
    public func wedge(for sieve: Triangle.Sieve) -> HexagonalDataStoreWedge<V> {
        
        let vertices = sieve.vertices.reduce(into: [Triangle.Vertex : V]()) { result, vertex in
            
            result[vertex] = value(for: vertex)
        }
        
        let tiles = sieve.tiles.reduce(into: [Triangle.Vertex : HexagonalDataStoreTile<V>]()) { result, tile in
            
            let vertices = tile.vertices.reduce(into: [Triangle.Vertex : V]()) { result, vertex in
                
                guard let value = vertices[vertex] else { return }
             
                result[vertex] = value
            }

            guard !vertices.isEmpty else { return }

            result[tile.vertex] = .init(tile: tile,
                                        vertices: vertices)
        }
        
        return .init(tiles: tiles)
    }
}
