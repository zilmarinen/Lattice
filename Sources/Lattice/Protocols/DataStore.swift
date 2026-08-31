//
//  DataStore.swift
//  Lattice
//
//  Created by Zack Brown on 29/08/2026.
//

import Deltille
import SpriteKit

internal protocol DataStore: SKNode {
    
    associatedtype C: DataStoreChunk<T, V>
    associatedtype R: DataStoreRegion<C, T, V>
    associatedtype T: Tile
    associatedtype V: DataStoreValue
    
    var regions: [R] { get }
    
    func region(for tile: T,
                _ from: Scale) -> R?
    
    func chunk(for tile: T,
               _ from: Scale) -> C?
    
    func remove(_ keys: Set<V.C>) -> Set<T>
    
    func set(_ value: V) -> Set<T>
    
    func value(for key: V.C) -> V?
}

internal extension DataStore {
    
    var regions: [R] {
        
        children.compactMap {
            
            $0 as? R
        }
    }
}

internal extension DataStore {
 
    func region(for tile: T,
                _ from: Scale) -> R? {
        
        let region = tile.transpose(from,
                                    .region)
        
        return regions.first {
            
            $0.tile == region
        }
    }
    
    func chunk(for tile: T,
               _ from: Scale) -> C? {
        
        guard let region = region(for: tile,
                                  from) else { return nil }
        
        return region.chunk(for: tile,
                            from)
    }
}

// MARK: Tile

internal extension DataStore where V.C == T {
    
    @discardableResult
    func remove(_ keys: Set<V.C>) -> Set<T> {
        
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
        
        return chunks
    }
    
    @discardableResult
    func set(_ value: V) -> Set<T> {
        
        for vertex in value.footprint {
            
            guard self.value(for: vertex) == nil else { return [] }
        }
        
        let partitions = value.footprint.reduce(into: [T : Set<V.C>]()) { result, vertex in
        
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
        
        return Set(partitions.keys)
    }
    
    func value(for key: V.C) -> V? {
        
        guard let chunk = chunk(for: key,
                                .tile) else { return nil }
        
        return chunk.value(for: key)
    }
}

// MARK: Vertex

internal extension DataStore where V.C == T.D.V {
    
    @discardableResult
    func remove(_ keys: Set<V.C>) -> Set<T> {
        
        let footprint = keys.reduce(into: Set<V.C>()) { result, vertex in
            
            guard let value = value(for: vertex) else { return }
            
            result.formUnion(value.footprint)
        }
        
        let tiles = Set(footprint.map {
        
            T($0.vector,
              2.0)
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
        
        return chunks
    }
    
    @discardableResult
    func set(_ value: V) -> Set<T> {
        
        for vertex in value.footprint {
            
            guard self.value(for: vertex) == nil else { return [] }
        }
        
        let partitions = value.footprint.reduce(into: [T : Set<V.C>]()) { result, vertex in
        
            let tile = T(vertex.vector,
                         2.0)
            
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
        
        return Set(partitions.keys)
    }
    
    func value(for key: V.C) -> V? {
        
        let tile = T(key.vector,
                     2.0)
        
        guard let chunk = chunk(for: tile,
                                .tile) else { return nil }
        
        return chunk.value(for: key)
    }
}
