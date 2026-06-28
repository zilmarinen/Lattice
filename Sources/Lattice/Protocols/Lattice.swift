//
//  Lattice.swift
//  Lattice
//
//  Created by Zack Brown on 10/03/2026.
//

import Deltille
import RealityKit

public protocol Lattice: Entity,
                         PropagatesChanges {
    
    associatedtype G: TriangularGrid<TriangularRegion<S.C>, S.C>
    associatedtype DS: DataStore
    associatedtype S: LatticeSlice

    typealias Cleaner = ((_ chunk: S.C,
                          _ sieve: Triangle.Sieve,
                          _ wedge: DataStoreWedge<DS.C.V>) -> Bool)
    
    var grid: G { get }
    var dataStore: DS { get }
    
    func value(for key: DS.K) -> DS.V?
    
    func set(_ value: DS.V,
             for key: DS.K)
    
    func remove(values keys: [DS.K])
    
    func wedge(for sieve: Triangle.Sieve) -> DataStoreWedge<DS.C.V>
    
    func merge(_ slice: S)
    
    func slice(region triangle: Triangle) -> S?
    
    func clean(_ cleaner: Cleaner)
}

public extension Lattice {
    
    func value(for key: DS.K) -> DS.V? {
        
        dataStore.value(for: key)
    }
    
    func wedge(for sieve: Triangle.Sieve) -> DS.W {
    
        dataStore.wedge(for: sieve)
    }
    
    func clean(_ cleaner: Cleaner) {
        
        var emptyRegions: [TriangularRegion<S.C>] = []
        
        for region in grid.dirtyRegions {
            
            var emptyChunks: [S.C] = []
            
            for chunk in region.dirtyChunks {
                
                let sieve = chunk.triangle.sieve(for: .chunk)
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
            
            guard region.children.isEmpty else { continue }
            
            emptyRegions.append(region)
        }
        
        emptyRegions.forEach {
            
            $0.removeFromParent()
        }
    }
}
