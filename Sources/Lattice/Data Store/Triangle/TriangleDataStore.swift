//
//  TriangleDataStore.swift
//  Lattice
//
//  Created by Zack Brown on 22/08/2026.
//

import Deltille
import SpriteKit

public class TriangleDataStore<V: DataStoreValue>: SKNode,
                                                   DataStore where V.C == Triangle {
    
    internal typealias C = DataStoreChunk<T, V>
    internal typealias R = DataStoreRegion<C, T, V>
    internal typealias T = Triangle
}

internal extension TriangleDataStore {
    
    var regions: [R] {
        
        children.compactMap {
            
            $0 as? R
        }
    }
}

internal extension TriangleDataStore {
    
    func region(for tile: Triangle,
                _ from: Scale) -> R? {
        
        let region = tile.transpose(from,
                                    .region)
        
        return regions.first {
            
            $0.tile == region
        }
    }
    
    func chunk(for tile: Triangle,
               _ from: Scale) -> C? {
        
        guard let region = self.region(for: tile,
                                       from) else { return nil }
        
        return region.chunk(for: tile,
                            from)
    }
}

internal extension TriangleDataStore {
    
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
        
        for vertex in value.footprint {
            
            guard self.value(for: vertex) == nil else { return }
        }
        
        let partitions = value.footprint.reduce(into: [Triangle : Set<V.C>]()) { result, vertex in
        
            let chunk = vertex.transpose(.tile,
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
        
        guard let chunk = chunk(for: key,
                                .tile) else { return nil }
        
        return chunk.value(for: key)
    }
}
