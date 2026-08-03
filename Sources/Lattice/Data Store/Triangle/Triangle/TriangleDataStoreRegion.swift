//
//  TriangleDataStoreRegion.swift
//  Lattice
//
//  Created by Zack Brown on 03/08/2026.
//

import Deltille

public class TriangleDataStoreRegion<C: TriangleDataStoreChunk<T>,
                                     T: DataStoreTile>: DataStoreContainer<Triangle, Triangle.Scale> where T.T == Triangle,
                                                                                                           T.T == T.V {
    
    internal var chunks: [C] = []
    
    required public init(_ triangle: Triangle) {
        
        super.init(triangle,
                   .region)
    }
    
    required public init(from decoder: any Decoder) throws {
        
        try super.init(from: decoder)
    }
}

internal extension TriangleDataStoreRegion {
    
    var isEmpty: Bool {
        
        chunks.isEmpty
    }
}

internal extension TriangleDataStoreRegion {
    
    func chunk(for triangle: Triangle,
               _ from: Triangle.Scale) -> C? {
        
        let transposed = triangle.transpose(from,
                                            .chunk)
        
        return chunks.first {
            
            $0.tile == transposed
        }
    }
    
    func chunks(intersecting region: Triangle) -> [C] {
        
        chunks.filter {
            
            $0.tile.transpose(.chunk,
                              .region) == region
        }
    }
    
    func remove(_ keys: [T.V]) {
     
        let unique = keys.unique(.tile,
                                 .chunk)
        
        for triangle in unique {
            
            guard let chunk = chunk(for: triangle,
                                    .chunk) else { continue }
            
            let values: [T.V] = keys.compactMap {
                
                $0.transpose(.tile,
                             .chunk) == triangle ? $0 : nil
            }
            
            chunk.remove(values)
            
            guard chunk.isEmpty,
                  let index = chunks.firstIndex(of: chunk) else { continue }
            
            chunks.remove(at: index)
        }
    }
    
    func set(_ value: T) {
        
        let footprint = value.footprint
        
        let unique = footprint.unique(.tile,
                                      .chunk)
        
        for triangle in unique {
            
            let chunk = chunk(for: triangle,
                              .chunk) ?? C(triangle)
            
            if chunks.firstIndex(of: chunk) == nil {
                
                chunks.append(chunk)
            }
            
            for tile in footprint {
                
                guard tile.transpose(.tile,
                                     .chunk) == triangle else { continue }
                
                chunk.set(value)
            }
        }
    }
}

//TODO: REMOVE
public class ExampleTriangleDataStoreRegion: TriangleDataStoreRegion<ExampleTriangleDataStoreChunk, ExampleTriangleTile> {
    
}
