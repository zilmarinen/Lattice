//
//  DataStore.swift
//  Lattice
//
//  Created by Zack Brown on 29/08/2026.
//

import Deltille
import SpriteKit

public protocol DataStore: SKNode {
    
    associatedtype C: DataStoreChunk<P, V>
    associatedtype G: Tile
    associatedtype R: DataStoreRegion<C, P, V>
    associatedtype P: Tile
    associatedtype V: DataStoreValue
    associatedtype W: Wedge
    
    var lattice: Double { get }
    
    var regions: [R] { get }
    
    func region(for tile: P,
                _ from: Scale) -> R?
    
    func chunk(for tile: P,
               _ from: Scale) -> C?
    
    func chunks(intersecting tile: P) -> [C]
    
    func remove(_ keys: Set<V.C>) -> Set<G>
    
    func set(_ value: V) -> Set<G>
    
    func value(for key: V.C) -> V?
    
    func wedge(for sieve: G.SI) -> W
}

public extension DataStore {
    
    var regions: [R] {
        
        children.compactMap {
            
            $0 as? R
        }
    }
}

public extension DataStore {
 
    func region(for tile: P,
                _ from: Scale) -> R? {
        
        let region = tile.transpose(from,
                                    .region)
        
        return regions.first {
            
            $0.tile == region
        }
    }
    
    func chunk(for tile: P,
               _ from: Scale) -> C? {
        
        guard let region = region(for: tile,
                                  from) else { return nil }
        
        return region.chunk(for: tile,
                            from)
    }
    
    func chunks(intersecting tile: P) -> [C] {
     
        regions.flatMap {
            
            $0.chunks(intersecting: tile)
        }
    }
}
