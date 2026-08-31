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
