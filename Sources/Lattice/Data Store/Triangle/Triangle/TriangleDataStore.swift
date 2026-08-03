//
//  TriangleDataStore.swift
//  Lattice
//
//  Created by Zack Brown on 03/08/2026.
//

import Deltille

public class TriangleDataStore<C: TriangleDataStoreChunk<T>,
                               R: TriangleDataStoreRegion<C, T>,
                               T: DataStoreTile>: DataStore {
    
    internal var regions: [R] = []
}

internal extension TriangleDataStore {
    
    func chunk(for triangle: Triangle,
               _ from: Triangle.Scale) -> C? {
        
        guard let region = region(for: triangle,
                                  from) else { return nil }
        
        return region.chunk(for: triangle,
                            from)
    }
    
    func chunks(intersecting region: Triangle) -> [C] {
        
        regions.flatMap {
            
            $0.chunks(intersecting: region)
        }
    }
    
    func region(for triangle: Triangle,
                _ from: Triangle.Scale) -> R? {
        
        let transposed = triangle.transpose(from,
                                            .region)
        
        return regions.first {
            
            $0.tile == transposed
        }
    }
}

public extension TriangleDataStore {
    
    func remove(_ keys: [T.V]) {
        
        var accumulated = Set<T.V>()
                
        for key in keys {
            
            guard !accumulated.contains(key),
                  let tile = value(for: key) else { continue }
            
            accumulated.formUnion(tile.footprint)
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
            
            region.remove(values)
            
            guard region.isEmpty,
                  let index = regions.firstIndex(of: region) else { continue }
            
            regions.remove(at: index)
        }
    }
    
    func set(_ value: T) {
        
        let footprint = value.footprint
        
        for tile in footprint {
            
            guard self.value(for: tile) == nil else { return }
        }
        
        let unique = footprint.unique(.tile,
                                      .region)
        
        for triangle in unique {
            
            let region = region(for: triangle,
                                .region) ?? R(triangle)
            
            if regions.firstIndex(of: region) == nil {
                
                regions.append(region)
            }
            
            region.set(value)
        }
    }
    
    func value(for key: T.V) -> T? {
        
        guard let chunk = chunk(for: key,
                                .tile) else { return nil }
        
        return chunk.value(for: key)
    }
}

//TODO: REMOVE
public class ExampleTriangleDataStore: TriangleDataStore<ExampleTriangleDataStoreChunk,ExampleTriangleDataStoreRegion, ExampleTriangleTile> {
    
}
