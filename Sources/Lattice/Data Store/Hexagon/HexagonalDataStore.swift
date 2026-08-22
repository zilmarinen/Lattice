//
//  HexagonalDataStore.swift
//  Lattice
//
//  Created by Zack Brown on 22/08/2026.
//

import Deltille
import SpriteKit

internal class HexagonalDataStore<V: DataStoreValue>: SKNode where V.C == Triangle.Vertex {
    
    internal typealias C = DataStoreChunk<Hexagon, Hexagon.Scale, V>
    internal typealias R = HexagonalDataStoreRegion<C, V>
}

internal extension HexagonalDataStore {
    
    var regions: [R] {
        
        children.compactMap {
            
            $0 as? R
        }
    }
}

internal extension HexagonalDataStore {
 
    func region(for hexagon: Hexagon,
                _ from: Hexagon.Scale) -> R? {
        
        let region = hexagon.transpose(from,
                                       .region)
        
        return regions.first {
            
            $0.tile == region
        }
    }
    
    func chunk(for hexagon: Hexagon,
               _ from: Hexagon.Scale) -> C? {
        
        guard let region = region(for: hexagon,
                                  from) else { return nil }
        
        return region.chunk(for: hexagon,
                            from)
    }
    
    func chunks(intersecting region: Triangle) -> [C] {
        
        regions.flatMap {
         
            $0.chunks(intersecting: region)
        }
    }
}

internal extension HexagonalDataStore {
    
    func remove(_ keys: Set<V.C>) {
        
        let footprint = keys.reduce(into: Set<V.C>()) { result, vertex in
            
            guard let value = value(for: vertex) else { return }
            
            result.formUnion(value.footprint)
        }
        
        let tiles = Set(footprint.map {
            
            Hexagon($0.vector)
        })
        
        let chunks = tiles.unique(.tile,
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
        
        let tile = Hexagon(key.vector)
        
        guard let chunk = chunk(for: tile,
                                .tile) else { return nil }
        
        return chunk.value(for: key)
    }
}

//TODO: REMOVE
internal class ExampleHexagonalDataStore: HexagonalDataStore<ExampleTriangleVertexValue> {
    
}
