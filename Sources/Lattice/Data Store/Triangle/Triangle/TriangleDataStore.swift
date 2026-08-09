//
//  TriangleDataStore.swift
//  Lattice
//
//  Created by Zack Brown on 03/08/2026.
//

import Deltille

public class TriangleDataStore<T: DataStoreTile>: DataStore where T.T == Triangle {
    
    internal typealias R = TriangleDataStoreRegion<T>
    
    internal var regions: [R] = []
}

internal extension TriangleDataStore {

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

        for tile in unique {

            guard let region = region(for: tile,
                                      .region) else { continue }

            region.remove(keys)

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

        for tile in unique {

            let region = region(for: tile,
                                .region) ?? R(tile,
                                              .region)
            
            if region.parent == nil {

                regions.append(region)
                
                region.parent = .zero
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
public class ExampleTriangleDataStore: TriangleDataStore<ExampleTriangleTile> {
    
}
