//
//  TileDataStore.swift
//  Lattice
//
//  Created by Zack Brown on 22/08/2026.
//

import Deltille
import SpriteKit

public class TileDataStore<T: Tile,
                           V: DataStoreValue>: SKNode,
                                               DataStore where V.C == T,
                                                               V.C == T.SI.T {
    
    public typealias C = DataStoreChunk<T, V>
    public typealias R = DataStoreRegion<C, T, V>
    
    public let lattice: Double
    
    public init(_ lattice: Double = 1.0) {
        
        self.lattice = lattice
        
        super.init()
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

public extension TileDataStore {
    
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
                                .region) ?? R(hexagon,
                                              lattice)
            
            if region.parent == nil {
                
                addChild(region)
            }
            
            for (partition, vertices) in partitions {
                
                guard partition.transpose(.chunk,
                                          .region) == hexagon else { continue }
                
                let chunk = region.chunk(for: partition,
                                         .chunk) ?? C(partition,
                                                      lattice)
                
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
    
    func wedge(for sieve: T.SI) -> DataStoreWedge<V.C, V> {
        
        let data = sieve.tiles.reduce(into: [V.C : V]()) { result, tile in
            
            result[tile] = value(for: tile)
        }
        
        return .init(data: data)
    }
}
