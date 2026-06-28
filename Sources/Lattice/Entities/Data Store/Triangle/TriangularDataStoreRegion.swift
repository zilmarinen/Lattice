//
//  TriangularDataStore.swift
//  Lattice
//
//  Created by Zack Brown on 07/03/2026.
//

import Deltille
import RealityKit

public class TriangularDataStoreRegion<C: TriangularDataStoreChunk<V>,
                                       V: TriangularDataStoreTile>: TriangularDataStoreContainer {
    
    required public init(_ triangle: Triangle) {
        
        super.init(triangle,
                   .region)
    }
    
    required public init(from decoder: any Decoder) throws {
        
        try super.init(from: decoder)
    }
}

internal extension TriangularDataStoreRegion {
    
    var chunks: [C] {
        
        children.compactMap {
            
            $0 as? C
        }
    }
}

internal extension TriangularDataStoreRegion {
    
    func chunk(for triangle: Triangle,
               _ from: Triangle.Scale) -> C? {
        
        let chunk = triangle.transpose(from,
                                       .chunk)
        
        return chunks.first {
            
            $0.triangle == chunk
        }
    }
    
    func chunks(intersecting triangle: Triangle,
                _ from: Triangle.Scale) -> [C] {
        
        let chunk = triangle.transpose(from,
                                       .chunk)
        
        return chunks.filter {
            
            $0.triangle == chunk
        }
    }
}

internal extension TriangularDataStoreRegion {
    
    func merge(_ chunk: C) {
        
        guard let existing = self.chunk(for: chunk.triangle,
                                        .chunk) else {
            
            return add(child: chunk)
        }
        
        existing.merge(chunk.store)
    }
    
    func set(_ value: V,
             for key: Triangle) {
        
        let unique = value.footprint.reduce(into: [Triangle : [Triangle]]()) { result, vertex in
            
            let tile = Triangle(vertex)
            
            guard tile.transpose(.tile,
                                 .region) == triangle else { return }
            
            let chunk = tile.transpose(.tile,
                                       .chunk)
            
            var values = result[chunk] ?? Array()
            
            values.append(tile)
            
            result[chunk] = values
        }
        
        for (triangle, values) in unique {
            
            let chunk = chunk(for: triangle,
                              .chunk) ?? C(triangle)
            
            if chunk.parent == nil {
                
                add(child: chunk)
            }
            
            for tile in values {
             
                chunk.set(value,
                          for: tile.vertex.position)
            }
        }
    }
    
    func remove(values keys: [Triangle]) {
     
        let unique = keys.unique(.tile,
                                 .chunk)
        
        var remaining = Set(keys)
        
        for triangle in unique {
            
            guard let chunk = chunk(for: triangle,
                                    .chunk) else { continue }
            
            let tiles = remaining.filter {
                
                $0.transpose(.tile,
                             .chunk) == triangle
            }
            
            remaining.subtract(tiles)
            
            chunk.remove(values: tiles.map { $0.vertex.position })
            
            guard chunk.isEmpty else { continue }
            
            chunk.removeFromParent()
        }
    }
}
