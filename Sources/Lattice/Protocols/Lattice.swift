//
//  Lattice.swift
//  Lattice
//
//  Created by Zack Brown on 29/08/2026.
//

import Deltille
import SpriteKit

public protocol Lattice: SKNode where S.G == T,
                                      S.V == V {
    
    associatedtype C: GridChunk<T>
    associatedtype G: Grid<R, C, T>
    associatedtype R: GridRegion<C, T>
    associatedtype S: DataStore
    associatedtype T: Tile
    associatedtype V: DataStoreValue
                                          
    typealias Cleaner = ((_ chunk: C,
                          _ sieve: T.SI,
                          _ wedge: S.W) -> Bool)
    
    var grid: G { get }
    var store: S { get }

    func clean(_ cleaner: Cleaner)
    
    func remove(_ keys: Set<V.C>)

    func set(_ value: V)
    
    func value(for key: V.C) -> V?
    
    func slice(for tile: T) -> DataStoreSlice<C, T, V>?
}

public extension Lattice {
    
    func clean(_ cleaner: Cleaner) {
        
        var emptyRegions: [R] = []
        
        for region in grid.dirtyRegions {
            
            var emptyChunks: [C] = []
            
            for chunk in region.dirtyChunks {
                
                let sieve = chunk.tile.sieve(.chunk)
                let wedge = store.wedge(for: sieve)
                
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
    
    func remove(_ keys: Set<V.C>) {
        
        let chunks = store.remove(keys)
        
        grid.propagate(chunks)
    }
    
    func set(_ value: V) {
        
        let chunks = store.set(value)
        
        grid.propagate(chunks,
                       true)
    }
    
    func slice(for tile: T) -> DataStoreSlice<C, T, V>? {
        return nil
//        guard let region = grid.region(for: tile,
//                                       .region) else { return nil }
//        
//        let chunks = store.chunks(intersecting: tile)
//        
//        return .init(chunks: chunks,
//                     region: region)
    }
    
    func value(for key: V.C) -> V? {
    
        store.value(for: key)
    }
}
