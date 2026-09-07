//
//  Lattice.swift
//  Lattice
//
//  Created by Zack Brown on 29/08/2026.
//

import Deltille
import SpriteKit

public protocol Lattice: SKNode where SI == G.T.SI,
                                      V == S.V {

    associatedtype G: Grid
    associatedtype S: DataStore
    associatedtype SI: Sieve
//    associatedtype SL: Slice
    associatedtype V: DataStoreValue
    associatedtype W: Wedge
                                          
    typealias Cleaner = ((_ chunk: G.C,
                          _ sieve: SI,
                          _ wedge: W) -> Bool)
    
    var grid: G { get }
    var store: S { get }
    
    func chunks(intersecting tile: G.T) -> [G.C]

    func clean(_ cleaner: Cleaner)
    
    func propagate(_ keys: Set<V.K>,
                   _ insertion: Bool)
    
    func remove(_ keys: Set<V.K>)

    func set(_ value: V)
    
//    func slice(for tile: G.T) -> SL?
    
    func value(for key: V.K) -> V?
    
    func wedge(for sieve: SI) -> W
}

public extension Lattice {
    
    func clean(_ cleaner: Cleaner) {

        var emptyRegions: [G.R] = []
        
        for region in grid.dirtyRegions {
            
            var emptyChunks: [G.C] = []
            
            for chunk in region.dirtyChunks {
                
                let sieve = chunk.tile.sieve(.chunk)
                let wedge = wedge(for: sieve)
                
                guard !wedge.isEmpty,
                      cleaner(chunk,
                              sieve,
                              wedge) else {
                    
                    emptyChunks.append(chunk)
                    
                    continue
                }
                
                chunk.isDirty = false
            }
            
            emptyChunks.forEach {
                
                $0.removeFromParent()
            }
            
            region.isDirty = false
            
            guard region.isEmpty else { continue }
            
            emptyRegions.append(region)
        }
        
        emptyRegions.forEach {
            
            $0.removeFromParent()
        }
    }
    
    func remove(_ keys: Set<V.K>) {
        
        store.remove(keys)
        
        propagate(keys,
                  false)
    }
    
    func set(_ value: V) {
        
        store.set(value)
        
        propagate(value.footprint,
                  true)
    }
    
    func value(for key: V.K) -> V? {
    
        store.value(for: key)
    }
}
