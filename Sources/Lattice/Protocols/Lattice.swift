//
//  Lattice.swift
//  Lattice
//
//  Created by Zack Brown on 29/08/2026.
//

import Deltille
import SpriteKit

public protocol Lattice: SKNode where G.T.SI == S.SI,
                                      G.T == S.I,
                                      V == S.V {

    associatedtype G: Grid
    associatedtype S: DataStore
    associatedtype SL: Slice
    associatedtype V: DataStoreValue
    
    var grid: G { get }
    var store: S { get }

    func clean()
    func clean(_ chunk: G.C,
               _ sieve: S.SI,
               _ wedge: S.W) -> Bool
    
    func propagate(_ keys: Set<V.K>,
                   _ insertion: Bool)
    
    func remove(_ keys: Set<V.K>)

    func set(_ value: V)
    
    func slice(for tile: G.T) -> SL?
    
    func value(for key: V.K) -> V?
}

public extension Lattice {
    
    func clean() {

        var emptyRegions: [G.R] = []
        
        for region in grid.dirtyRegions {
            
            var emptyChunks: [G.C] = []
            
            for chunk in region.dirtyChunks {
                
                let sieve = chunk.tile.sieve(.chunk)
                let wedge = store.wedge(for: sieve)
                
                guard !wedge.isEmpty,
                      clean(chunk,
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
    
    func clean(_ chunk: G.C,
               _ sieve: S.SI,
               _ wedge: S.W) -> Bool {
        
        false
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
    
    func slice(for tile: G.T) -> LatticeSlice<G.C, S.T, G.T, V>? {
        
        guard let region = grid.region(for: tile,
                                       .region) else { return nil }
        
        let chunks = store.chunks(intersecting: tile)
        
        return .init(chunks: chunks,
                     region: region)
    }
    
    func value(for key: V.K) -> V? {
    
        store.value(for: key)
    }
}
