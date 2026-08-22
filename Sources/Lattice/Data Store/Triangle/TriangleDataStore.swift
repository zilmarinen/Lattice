//
//  TriangularDataStore.swift
//  Lattice
//
//  Created by Zack Brown on 22/08/2026.
//

import Deltille
import SpriteKit

internal class TriangularDataStore<V: DataStoreValue>: SKNode where V.C == Triangle {
    
    internal typealias C = DataStoreChunk<Triangle, Triangle.Scale, V>
    internal typealias R = TriangularDataStoreRegion<C, V>
}

internal extension TriangularDataStore {
    
    var regions: [R] {
        
        children.compactMap {
            
            $0 as? R
        }
    }
}

internal extension TriangularDataStore {
    
    func region(for triangle: Triangle,
                _ from: Triangle.Scale) -> R? {
        
        let region = triangle.transpose(from,
                                        .region)
        
        return regions.first {
            
            $0.tile == region
        }
    }
    
    func chunk(for triangle: Triangle,
               _ from: Triangle.Scale) -> C? {
        
        guard let region = self.region(for: triangle,
                                       from) else { return nil }
        
        return region.chunk(for: triangle,
                            from)
    }
    
    func chunks(intersecting region: Triangle) -> [C] {
        
        regions.flatMap {
            
            $0.chunks(intersecting: region)
        }
    }
}

internal extension TriangularDataStore {
    
    func remove(_ keys: Set<V.C>) {
        
        let footprint = keys.reduce(into: Set<V.C>()) { result, vertex in
            
            guard let value = value(for: vertex) else { return }
            
            result.formUnion(value.footprint)
        }
        
        let chunks = footprint.unique(.tile,
                                      .chunk)
        
        for hexagon in chunks {
            
            guard let chunk = chunk(for: hexagon,
                                    .chunk) else { continue }
            
            chunk.remove(footprint)
            
            guard chunk.isEmpty,
                  let region = chunk.parent as? R else { continue }
            
            chunk.removeFromParent()
            
            guard region.isEmpty else { continue }
            
            region.removeFromParent()
        }
    }
    
    func set(_ value: V) {
        
        
    }
    
    func value(for key: V.C) -> V? {
        
        guard let chunk = chunk(for: key,
                                .tile) else { return nil }
        
        return chunk.value(for: key)
    }
}

//TODO: REMOVE
internal class ExampleTriangularDataStore: TriangularDataStore<ExampleTriangleValue> {
    
}
