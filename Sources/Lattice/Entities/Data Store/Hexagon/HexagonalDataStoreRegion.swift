//
//  HexagonalDataStoreRegion.swift
//  Lattice
//
//  Created by Zack Brown on 08/03/2026.
//

import Deltille
import Foundation
import RealityKit

open class HexagonalDataStoreRegion<C: HexagonalDataStoreChunk<V>,
                                    V: DataStoreValue>: HexagonalRegion<C> {
    
    internal func merge(_ chunk: C) {
        
        guard let existing = self.chunk(for: chunk.hexagon,
                                        .chunk) else {
        
            return addChild(chunk)
        }
        
        existing.merge(chunk.store)
    }
    
    internal func set(_ value: V,
                    for key: Triangle.Vertex) {
        
        let hexagon = Hexagon(key.position(.tile),
                              .chunk)
        
        let chunk = chunk(for: hexagon,
                          .chunk) ?? C(hexagon)
        
        if chunk.parent == nil {
            
            addChild(chunk)
        }
        
        chunk.set(value,
                  for: key.position)
    }
    
    internal func remove(values keys: [Triangle.Vertex]) {
        
        let unique = keys.reduce(into: [Hexagon : [Triangle.Vertex]]()) { result, vertex in
            
            let hexagon = Hexagon(vertex.position(.tile),
                                  .chunk)
            
            var values = result[hexagon] ?? Array()
            
            values.append(vertex)
            
            result[hexagon] = values
        }
        
        for (hexagon, values) in unique {
            
            guard let chunk = chunk(for: hexagon,
                                    .chunk) else { continue }
            
            chunk.remove(values: values.map { $0.position })
            
            guard chunk.isEmpty else { return }
            
            chunk.removeFromParent()
        }
    }
}
