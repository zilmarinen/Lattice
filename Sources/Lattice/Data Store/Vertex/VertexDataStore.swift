//
//  VertexDataStore.swift
//  Lattice
//
//  Created by Zack Brown on 28/08/2026.
//

import Deltille
import SpriteKit

public class VertexDataStore<V: DataStoreValue>: SKNode,
                                                 DataStore where V.K == V.T.D.V,
                                                                 V.K == V.T.D.SI.V {
    
    public typealias C = DataStoreChunk<V.T, V>
    public typealias R = DataStoreRegion<C, V.T, V>
    public typealias T = V.T
    
    public let lattice: Double
    
    public init(_ lattice: Double = 1.0) {
        
        self.lattice = lattice
        
        super.init()
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

public extension VertexDataStore {
    
    func chunks(intersecting tile: V.T.D) -> [C] {
        
        regions.flatMap { region in
            
            region.chunks.filter { chunk in
            
                for vertex in chunk.tile.vertices(.chunk) {
                    
                    let dual = V.T.D(vertex.vector(lattice * 2.0),
                                     lattice)
                    
                    let region = dual.transpose(.tile,
                                                .region)
                    
                    if region == tile {
                        
                        return true
                    }
                }
                
                return false
            }
        }
    }
    
    func remove(_ keys: Set<V.K>) {
        
        let footprint = keys.reduce(into: Set<V.K>()) { result, vertex in
            
            guard let value = value(for: vertex) else { return }
            
            result.formUnion(value.footprint)
        }
        
        let transposed = Set(footprint.map {
        
            T($0.vector(lattice),
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
    }
    
    func set(_ value: V) {
        
        for vertex in value.footprint {
            
            guard self.value(for: vertex) == nil else { return }
        }
        
        let partitions = value.footprint.reduce(into: [T : Set<V.K>]()) { result, vertex in
        
            let tile = T(vertex.vector(lattice),
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
    }
    
    func value(for key: V.K) -> V? {
        
        let tile = T(key.vector(lattice),
                     lattice * 2.0)
        
        guard let chunk = chunk(for: tile,
                                .tile) else { return nil }
        
        return chunk.value(for: key)
    }
    
    func wedge(for sieve: T.D.SI) -> DataStoreWedge<V.K, V> {
        
        let data = sieve.vertices.reduce(into: [V.K : V]()) { result, vertex in
                    
            result[vertex] = value(for: vertex)
        }
        
        return .init(data: data)
    }
}
