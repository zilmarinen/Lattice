//
//  Lattice.swift
//  Lattice
//
//  Created by Zack Brown on 10/03/2026.
//

import Deltille
import RealityKit

public protocol Lattice: Entity {
    
    associatedtype G: TriangularGrid<TriangularRegion<S.C>, S.C>
    associatedtype D: DataStore
    associatedtype S: LatticeSlice
    
    typealias Cleaner = ((_ chunk: S.C,
                          _ wedge: D.W) -> Bool)
    
    var grid: G { get }
    var dataStore: D { get }
    
    func value(for key: D.K) -> D.V?
    
    func set(_ value: D.V?,
             for key: D.K)
    
    func remove(values keys: [D.K])
    
    func wedge(for sieve: Triangle.Sieve) -> D.W
    
    func merge(_ slice: S)
    
    func slice(region triangle: Triangle) -> S?
    
    func propagate(triangle tile: Triangle)
    func propagate(vertex: Triangle.Vertex)
    
    func clean(_ cleaner: Cleaner)
}

public extension Lattice {
    
    func value(for key: D.K) -> D.V? {
        
        dataStore.value(for: key)
    }
    
    func wedge(for sieve: Triangle.Sieve) -> D.W {
    
        dataStore.wedge(for: sieve)
    }
    
    func propagate(triangle tile: Triangle) {
     
        grid.propagate(triangle: tile)
    }

    func propagate(vertex: Triangle.Vertex) {
        
        grid.propagate(vertex: vertex)
    }
    
    func clean(_ cleaner: Cleaner) {
        
        var emptyRegions: [TriangularRegion<S.C>] = []
        
        for region in grid.dirtyRegions {
            
            var emptyChunks: [S.C] = []
            
            for chunk in region.dirtyChunks {
                
                let wedge = wedge(for: chunk.triangle.sieve(for: .chunk))
                
                guard !wedge.isEmpty,
                      cleaner(chunk,
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
