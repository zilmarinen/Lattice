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
                                V: DataStoreValue>: HexagonalGrid<R, C>,
                                                    DataStore {
    
    public func merge(_ chunks: [C]) {
        
        chunks.forEach {
            
            let region = region(for: $0.hexagon,
                                .chunk) ?? R($0.hexagon.transpose(.chunk,
                                                                  .region))
            
            if region.parent == nil {
                
                addChild(region)
            }
            
            region.merge($0)
        }
    }
    
    public func value(for key: Triangle.Vertex) -> V? {
        
        let hexagon = Hexagon(key.position(.tile),
                              .chunk)
        
        guard let chunk = chunk(for: hexagon,
                                .chunk) else { return nil }
        
        return chunk.value(for: key)
    }
    
    public func set(_ value: V,
                    for key: Triangle.Vertex) {
        
        let hexagon = Hexagon(key.position(.tile),
                              .region)
        
        let region = region(for: hexagon,
                            .region) ?? R(hexagon)
        
        if region.parent == nil {
            
            addChild(region)
        }
        
        region.set(value,
                   for: key)
    }
    
    public func remove(values keys: [Triangle.Vertex]) {
        
        let unique = keys.reduce(into: [Hexagon : [Triangle.Vertex]]()) { result, vertex in
            
            let hexagon = Hexagon(vertex.position(.tile),
                                  .region)
            
            var values = result[hexagon] ?? Array()
            
            values.append(vertex)
            
            result[hexagon] = values
        }
        
        for (hexagon, values) in unique {
            
            guard let region = region(for: hexagon,
                                      .region) else { continue }
            
            region.remove(values: values)
            
            guard region.numberOfDescendants == 0 else { return }
            
            region.removeFromParent()
        }
    }
    
    public func wedge(for sieve: Triangle.Sieve) -> W {
        
        let data = sieve.vertices.reduce(into: [C.K : C.V]()) { result, vertex in
            
            result[vertex] = value(for: vertex)
        }
        
        return .init(data: data)
    }
}
