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
    associatedtype D: DataStore
    associatedtype S: LatticeSlice
    
    typealias Cleaner = ((_ chunk: S.C,
                          _ sieve: Triangle.Sieve,
                          _ wedge: DataStoreWedge<D.C.V>) -> Bool)
    
    var grid: G { get }
    var dataStore: D { get }
    
    func value(for key: D.K) -> D.V?
    
    func set(_ value: D.V,
             for key: D.K)
    
    func remove(values keys: [D.K])
    
    func wedge(for sieve: Triangle.Sieve) -> DataStoreWedge<D.C.V>
    
    func merge(_ slice: S)
    
    func slice(region triangle: Triangle) -> S?
    
    func clean(_ cleaner: Cleaner)
}

public extension Lattice {
    
    func value(for key: D.K) -> D.V? {
        
        dataStore.value(for: key)
    }
    
    func wedge(for sieve: Triangle.Sieve) -> D.W {
    
        dataStore.wedge(for: sieve)
    }
    
    func propagate(triangle: Triangle,
                   _ createHierarchy: Bool = false) {
     
        grid.propagate(triangle: triangle,
                       createHierarchy)
    }

    func propagate(vertex: Triangle.Vertex,
                   _ createHierarchy: Bool = false) {
        
        grid.propagate(vertex: vertex,
                       createHierarchy)
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
            
            guard region.numberOfDescendants == 0 else { continue }
            
            emptyRegions.append(region)
        }
        
        emptyRegions.forEach {
            
            $0.removeFromParent()
        }
    }
}
