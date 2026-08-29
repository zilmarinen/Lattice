//
//  HexagonVertexDataStore.swift
//  Lattice
//
//  Created by Zack Brown on 28/08/2026.
//

import Deltille
import SpriteKit

internal class HexagonVertexDataStore<V: DataStoreValue>: SKNode,
                                                          DataStore where V.C == Hexagon.Vertex {
    
    internal typealias C = DataStoreChunk<Triangle, V>
    internal typealias R = TriangularDataStoreRegion<C, V>
}

internal extension HexagonVertexDataStore {
    
    var regions: [R] {
        
        children.compactMap {
            
            $0 as? R
        }
    }
}

internal extension HexagonVertexDataStore {
    
    func region(for triangle: Triangle,
                _ from: Scale) -> R? {
        
        let region = triangle.transpose(from,
                                        .region)
        
        return regions.first {
            
            $0.tile == region
        }
    }
    
    func chunk(for triangle: Triangle,
               _ from: Scale) -> C? {
        
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

internal extension HexagonVertexDataStore {
    
    func remove(_ keys: Set<V.C>) {
        
        let footprint = keys.reduce(into: Set<V.C>()) { result, vertex in
            
            guard let value = value(for: vertex) else { return }
            
            result.formUnion(value.footprint)
        }
        
        let tiles = Set(footprint.map {
            
            Triangle($0.vector)
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
        
        let partitions = value.footprint.reduce(into: [Triangle : Set<V.C>]()) { result, vertex in
        
            let tile = Triangle(vertex.vector)
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
        
        let tile = Triangle(key.vector)
        
        guard let chunk = chunk(for: tile,
                                .tile) else { return nil }
        
        return chunk.value(for: key)
    }
}
