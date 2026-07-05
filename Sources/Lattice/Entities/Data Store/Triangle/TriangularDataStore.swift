//
//  TriangularDataStore.swift
//  Lattice
//
//  Created by Zack Brown on 07/03/2026.
//

import Deltille
import RealityKit

open class TriangularDataStore<R: TriangularDataStoreRegion<C, V>,
                               C: TriangularDataStoreChunk<V>,
                               V: TriangularDataStoreTile>: DataStoreContainer<Triangle, Triangle.Scale>,
                                                            DataStore {
    
    required public init() {
        
        super.init(.zero,
                   .region)
    }
    
    required public init(from decoder: any Decoder) throws {
        
        try super.init(from: decoder)
    }
}

internal extension TriangularDataStore {
    
    var regions: [R] {
        
        children?.compactMap {
            
            $0 as? R
            
        } ?? []
    }
}

public extension TriangularDataStore {
    
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

public extension TriangularDataStore {
    
    func merge(_ region: R) {
        
        guard let existing = self.region(for: region.tile,
                                         .region) else {
            
            return add(child: region)
        }
        
        for chunk in region.chunks {
            
            guard existing.chunk(for: chunk.tile,
                                 .chunk) == nil else { continue }
            
            existing.add(child: chunk)
        }
    }
    
    func merge(_ chunks: [C]) {
        
        chunks.forEach {
            
            let region = region(for: $0.tile,
                                .chunk) ?? R($0.tile.transpose(.chunk,
                                                               .region))
            
            if region.parent == nil {
                
                add(child: region)
            }
            
            region.merge($0)
        }
    }
    
    func value(for key: Triangle) -> V? {
        
        guard let chunk = chunk(for: key,
                                .tile) else { return nil }
        
        return chunk.value(for: key.vertex.position)
    }
    
    func set(_ value: V,
             for key: Triangle) {
        
        let tiles = value.tiles
        
        for tile in value.tiles {
            
            guard self.value(for: tile) == nil else { return }
        }
        
        let unique = tiles.unique(.tile,
                                  .region)
        
        for triangle in unique {
            
            let region = region(for: triangle,
                                .region) ?? R(triangle)
            
            if region.parent == nil {
                
                add(child: region)
            }
            
            region.set(value,
                       for: key)
        }
    }
     
    func remove(values keys: [Triangle]) {
        
        var accumulated = Set<Triangle>()
        
        for key in keys {
            
            guard !accumulated.contains(key),
                  let tile = value(for: key) else { continue }
            
            accumulated.formUnion(tile.tiles)
        }
        
        let keys = Array(accumulated)
        
        let unique = keys.unique(.tile,
                                 .region)
        
        for triangle in unique {
            
            guard let region = region(for: triangle,
                                      .region) else { continue }
            
            let values = keys.filter {
                
                $0.transpose(.tile,
                             .region) == triangle
            }
            
            region.remove(values: values)
            
            guard !region.hasChildren else { continue }
            
            region.removeFromParent()
        }
    }
    
    func wedge(for sieve: Triangle.Sieve) -> W {
        
        let data = sieve.triangles.reduce(into: [Triangle.Vertex : C.V]()) { result, triangle in
            
            result[triangle.vertex] = value(for: triangle)
        }
        
        return .init(data: data)
    }
}
