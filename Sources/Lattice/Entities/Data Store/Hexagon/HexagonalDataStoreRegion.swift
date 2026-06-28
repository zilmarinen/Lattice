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
                                    V: DataStoreValue>: HexagonalDataStoreContainer {
    
    required public init(_ hexagon: Hexagon) {
        
        super.init(hexagon,
                   .region)
    }
    
    required public init(from decoder: any Decoder) throws {
        
        try super.init(from: decoder)
    }
}

internal extension HexagonalDataStoreRegion {
    
    var chunks: [C] {
        
        children.compactMap {
            
            $0 as? C
        }
    }
}

internal extension HexagonalDataStoreRegion {
    
    func chunk(for hexagon: Hexagon,
               _ from: Hexagon.Scale) -> C? {
        
        let chunk = hexagon.transpose(from,
                                      .chunk)
        
        return chunks.first {
            
            $0.hexagon == chunk
        }
    }
    
    func chunks(intersecting triangle: Triangle,
                _ from: Triangle.Scale) -> [C] {
        
        chunks.filter {
            
            for vertex in $0.hexagon.vertices {
                
                let match = Triangle(vertex.position(.chunk),
                                     from)
                
                if match == triangle {
                    
                    return true
                }
            }
            
            for vertex in triangle.vertices {
                
                let match = Hexagon(vertex.position(from),
                                    .chunk)
                
                if match == $0.hexagon {
                    
                    return true
                }
            }
            
            return false
        }
    }
}

internal extension HexagonalDataStoreRegion {
    
    func merge(_ chunk: C) {
        
        guard let existing = self.chunk(for: chunk.hexagon,
                                        .chunk) else {
        
            return add(child: chunk)
        }
        
        existing.merge(chunk.store)
    }
    
    func set(_ value: V,
             for key: Triangle.Vertex) {
        
        let hexagon = Hexagon(key.position(.tile),
                              .chunk)
        
        let chunk = chunk(for: hexagon,
                          .chunk) ?? C(hexagon)
        
        if chunk.parent == nil {
            
            add(child: chunk)
        }
        
        chunk.set(value,
                  for: key.position)
    }
    
    func remove(values keys: [Triangle.Vertex]) {
        
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
