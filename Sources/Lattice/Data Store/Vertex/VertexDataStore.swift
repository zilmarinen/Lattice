//
//  VertexDataStore.swift
//  Lattice
//
//  Created by Zack Brown on 28/08/2026.
//

import Deltille
import SpriteKit

public class VertexDataStore<G: Tile,
                             V: DataStoreValue>: SKNode,
                                                 DataStore where V.C == G.V,
                                                                 V.C == G.SI.V,
                                                                 V.C.T == G {
    
    public typealias C = DataStoreChunk<P, V>
    public typealias P = G.D
    public typealias R = DataStoreRegion<C, P, V>
    
    public let lattice: Double
    
    public init(_ lattice: Double = 1.0) {
        
        self.lattice = lattice
        
        super.init()
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

public extension VertexDataStore {
    
    @discardableResult
    func remove(_ keys: Set<V.C>) -> Set<G> {
        
        let footprint = keys.reduce(into: Set<V.C>()) { result, vertex in
            
            guard let value = value(for: vertex) else { return }
            
            result.formUnion(value.footprint)
        }
        
        let transposed = Set(footprint.map {
        
            P($0.vector(lattice),
              lattice * 2.0)
        })
        
        let chunks = transposed.unique(.tile,
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
        
        let tiles = footprint.flatMap {
            
            $0.tiles
        }
        
        return tiles.unique(.tile,
                            .chunk)
    }
    
    @discardableResult
    func set(_ value: V) -> Set<G> {
        
        for vertex in value.footprint {
            
            guard self.value(for: vertex) == nil else { return [] }
        }
        
        let partitions = value.footprint.reduce(into: [P : Set<V.C>]()) { result, vertex in
        
            let tile = P(vertex.vector(lattice),
                         lattice * 2.0)
            
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
                                .region) ?? R(hexagon,
                                              lattice * 2.0)
            
            if region.parent == nil {
                
                addChild(region)
            }
            
            for (partition, vertices) in partitions {
                
                guard partition.transpose(.chunk,
                                          .region) == hexagon else { continue }
                
                let chunk = region.chunk(for: partition,
                                         .chunk) ?? C(partition,
                                                      lattice * 2.0)
                
                if chunk.parent == nil {
                    
                    region.addChild(chunk)
                }
                
                for vertex in vertices {

                    chunk.set(value,
                              for: vertex)
                }
            }
        }
        
        let tiles = value.footprint.flatMap {
            
            $0.tiles
        }
        
        return tiles.unique(.tile,
                            .chunk)
    }
    
    func value(for key: V.C) -> V? {
        
        let tile = P(key.vector(lattice),
                     lattice * 2.0)
        
        guard let chunk = chunk(for: tile,
                                .tile) else { return nil }
        
        return chunk.value(for: key)
    }
    
    func wedge(for sieve: G.SI) -> DataStoreWedge<V.C, V> {
        
        let data = sieve.vertices.reduce(into: [V.C : V]()) { result, vertex in
                    
            result[vertex] = value(for: vertex)
        }
        
        return .init(data: data)
    }
}
