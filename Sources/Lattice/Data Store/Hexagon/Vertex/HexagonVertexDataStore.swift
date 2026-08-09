//
//  HexagonVertexDataStore.swift
//  Lattice
//
//  Created by Zack Brown on 03/08/2026.
//

import Deltille

import Deltille

public class HexagonVertexDataStore<V: DataStoreValue>: DataStore where V.V == Hexagon.Vertex {
    
    internal typealias R = HexagonVertexDataStoreRegion<V>
    
    internal var regions: [R] = []
}

internal extension HexagonVertexDataStore {

    func chunk(for tile: Triangle,
               _ from: Triangle.Scale) -> R.C? {

        guard let region = region(for: tile,
                                  from) else { return nil }

        return region.chunk(for: tile,
                            from)
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

public extension HexagonVertexDataStore {

    func remove(_ keys: [V.V]) {
        
        let triangles = keys.map {
            
            Triangle($0)
        }
        
        let unique = triangles.unique(.tile,
                                      .region)
        
        for tile in unique {
            
            guard let region = region(for: tile,
                                      .region) else { continue }

            region.remove(keys)

            guard region.isEmpty,
                  let index = regions.firstIndex(of: region) else { continue }

            regions.remove(at: index)
        }
    }

    func set(_ value: V) {
        
        let triangle = Triangle(value.vertex)
        
        let transposed = triangle.transpose(.tile,
                                            .region)
        
        let region = region(for: transposed,
                            .region) ?? R(transposed,
                                          .region)
        
        if region.parent == nil {

            regions.append(region)
            
            region.parent = .zero
        }
        
        region.set(value)
    }

    func value(for key: V.V) -> V? {
        
        let triangle = Triangle(key)

        guard let chunk = chunk(for: triangle,
                                .tile) else { return nil }

        return chunk.value(for: key)
    }
}

//TODO: REMOVE
public class ExampleHexagonVertexDataStore: HexagonVertexDataStore<ExampleHexagonVertexValue> {
    
}
