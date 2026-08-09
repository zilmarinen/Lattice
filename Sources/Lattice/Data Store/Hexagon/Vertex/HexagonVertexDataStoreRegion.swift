//
//  HexagonVertexDataStoreRegion.swift
//  Lattice
//
//  Created by Zack Brown on 09/08/2026.
//

import Deltille

public class HexagonVertexDataStoreRegion<V: DataStoreValue>: DataStoreContainer<Triangle, Triangle.Scale> where V.V == Hexagon.Vertex {
    
    internal typealias C = DataStoreChunk<Triangle, Triangle.Scale, V>

    internal var chunks: [C] = []
}

internal extension HexagonVertexDataStoreRegion {
    
    var isEmpty: Bool {
        
        chunks.isEmpty
    }
}

internal extension HexagonVertexDataStoreRegion {
    
    func chunk(for tile: Triangle,
               _ from: Triangle.Scale) -> C? {
        
        let transposed = tile.transpose(from,
                                        .chunk)
        
        return chunks.first {
            
            $0.tile == transposed
        }
    }
    
    func remove(_ keys: [V.V]) {
     
        let triangles = keys.map {
            
            Triangle($0)
        }
        
        let unique = triangles.unique(.tile,
                                      .chunk)
        
        for tile in unique {
            
            guard let chunk = chunk(for: tile,
                                    .chunk) else { continue }
            
            chunk.remove(keys)
            
            guard chunk.isEmpty,
                  let index = chunks.firstIndex(of: chunk) else { continue }
            
            chunks.remove(at: index)
        }
    }
    
    func set(_ value: V) {
        
        let triangle = Triangle(value.vertex)
        
        let transposed = triangle.transpose(.tile,
                                            .chunk)
        
        let chunk = chunk(for: transposed,
                          .chunk) ?? C(transposed,
                                       .chunk)
        
        if chunk.parent == nil {
            
            chunks.append(chunk)
            
            chunk.parent = .zero
        }
        
        chunk.set(value)
    }
}

//TODO: REMOVE
public class ExampleHexagonVertexDataStoreRegion: HexagonVertexDataStoreRegion<ExampleHexagonVertexValue> {
    
}
