//
//  TriangleVertexDataStore.swift
//  Lattice
//
//  Created by Zack Brown on 28/08/2026.
//

import Deltille
import SpriteKit

public class TriangleVertexDataStore<V: DataStoreValue>: SKNode,
                                                         DataStore where V.C == Triangle.Vertex {
    
    internal typealias C = DataStoreChunk<T, V>
    internal typealias R = DataStoreRegion<C, T, V>
    internal typealias T = Hexagon
}

internal extension TriangleVertexDataStore {
    
    var regions: [R] {
        
        children.compactMap {
            
            $0 as? R
        }
    }
}

internal extension TriangleVertexDataStore {
 
    func region(for tile: Hexagon,
                _ from: Scale) -> R? {
        
        let region = tile.transpose(from,
                                    .region)
        
        return regions.first {
            
            $0.tile == region
        }
    }
    
    func chunk(for tile: Hexagon,
               _ from: Scale) -> C? {
        
        guard let region = region(for: tile,
                                  from) else { return nil }
        
        return region.chunk(for: tile,
                            from)
    }
}

internal extension TriangleVertexDataStore {
    
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
        
        for vertex in value.footprint {
            
            guard self.value(for: vertex) == nil else { return }
        }
        
        let partitions = value.footprint.reduce(into: [Hexagon : Set<V.C>]()) { result, vertex in
        
            let tile = Hexagon(vertex.vector)
            let chunk = tile.transpose(.tile,
                                       .chunk)
            
            var partition = result[chunk] ?? []
            
            partition.insert(vertex)
            
            result[chunk] = partition
        }
        
        let regions = partitions.keys.unique(.chunk,
                                             .region)
        
        for hexagon in regions {
            
            let region = region(for: hexagon,
                                .region) ?? R(hexagon)
            
            if region.parent == nil {
                
                addChild(region)
            }
            
            for (partition, vertices) in partitions {
                
                guard partition.transpose(.chunk,
                                          .region) == hexagon else { continue }
                
                let chunk = region.chunk(for: partition,
                                         .chunk) ?? C(partition,
                                                      .chunk)
                
                if chunk.parent == nil {
                    
                    region.addChild(chunk)
                }
                
                for vertex in vertices {
                    
                    chunk.set(value,
                              for: vertex)
                }
            }
        }
    }
    
    func value(for key: V.C) -> V? {
        
        let tile = Hexagon(key.vector)
        
        guard let chunk = chunk(for: tile,
                                .tile) else { return nil }
        
        return chunk.value(for: key)
    }
}
