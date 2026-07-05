//
//  HexagonalDataStore.swift
//  Lattice
//
//  Created by Zack Brown on 08/03/2026.
//

import Deltille
import RealityKit

open class HexagonalDataStore<R: HexagonalDataStoreRegion<C, V>,
                              C: HexagonalDataStoreChunk<V>,
                              V: DataStoreValue>: HexagonalDataStoreContainer,
                                                  DataStore {
    
    required public init() {
        
        super.init(.zero,
                   .region)
    }
    
    required public init(from decoder: any Decoder) throws {
        
        try super.init(from: decoder)
    }
}

internal extension HexagonalDataStore {
    
    var regions: [R] {
        
        children?.compactMap {
            
            $0 as? R
            
        } ?? []
    }
}

public extension HexagonalDataStore {
    
    func region(for hexagon: Hexagon,
                _ from: Hexagon.Scale) -> R? {
        
        let region = hexagon.transpose(from,
                                       .region)
        
        return regions.first {
            
            $0.hexagon == region
        }
    }
    
    func chunk(for chunk: Hexagon,
               _ from: Hexagon.Scale) -> C? {
        
        guard let region = region(for: chunk,
                                  from) else { return nil }
        
        return region.chunk(for: chunk,
                            from)
    }
    
    func chunks(intersecting triangle: Triangle,
                _ from: Triangle.Scale) -> [C] {
        
        regions.flatMap {
         
            $0.chunks(intersecting: triangle,
                      from)
        }
    }
}

public extension HexagonalDataStore {
    
    func merge(_ region: R) {
        
        guard let existing = self.region(for: region.hexagon,
                                         .region) else {
            
            return add(child: region)
        }
        
        for chunk in region.chunks {
            
            guard existing.chunk(for: chunk.hexagon,
                                 .chunk) == nil else { continue }
            
            existing.add(child: chunk)
        }
    }

    func merge(_ chunks: [C]) {
        
        chunks.forEach {
            
            let region = region(for: $0.hexagon,
                                .chunk) ?? R($0.hexagon.transpose(.chunk,
                                                                  .region))
            
            if region.parent == nil {
                
                add(child: region)
            }
            
            region.merge($0)
        }
    }
    
    func value(for key: Triangle.Vertex) -> V? {
        
        let hexagon = Hexagon(key.position(.tile),
                              .chunk)
        
        guard let chunk = chunk(for: hexagon,
                                .chunk) else { return nil }
        
        return chunk.value(for: key.position)
    }
    
    func set(_ value: V,
             for key: Triangle.Vertex) {
        
        let hexagon = Hexagon(key.position(.tile),
                              .region)
        
        let region = region(for: hexagon,
                            .region) ?? R(hexagon)
        
        if region.parent == nil {
            
            add(child: region)
        }
        
        region.set(value,
                   for: key)
    }
    
    func remove(values keys: [Triangle.Vertex]) {
        
        let unique = keys.reduce(into: [Hexagon : [Triangle.Vertex]]()) { result, vertex in
            
            let region = Hexagon(vertex.position(.tile),
                                 .region)
            
            var values = result[region] ?? Array()
            
            values.append(vertex)
            
            result[region] = values
        }
        
        for (hexagon, values) in unique {
            
            guard let region = region(for: hexagon,
                                      .region) else { continue }
            
            region.remove(values: values)
            
            guard !region.hasChildren else { continue }
            
            region.removeFromParent()
        }
    }
    
    func wedge(for sieve: Triangle.Sieve) -> W {
        
        let data = sieve.vertices.reduce(into: [Triangle.Vertex : C.V]()) { result, vertex in
            
            result[vertex] = value(for: vertex)
        }
        
        return .init(data: data)
    }
}
