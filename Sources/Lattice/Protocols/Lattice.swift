//
//  Lattice.swift
//  Lattice
//
//  Created by Zack Brown on 10/03/2026.
//

import Deltille
import RealityKit

public protocol Lattice: Entity {
    
    associatedtype C: TriangularChunk
    associatedtype G: TriangularGrid<TriangularRegion<C>, C>
    associatedtype D: DataStore
    associatedtype S: LatticeSlice
    
    typealias Cleaner = ((_ wedge: D.W, _ chunk: C) -> Bool)
    
    var grid: G { get }
    var dataStore: D { get }
    
    func value(for key: D.K) -> D.V?
    
    func set(_ value: D.V?,
             for key: D.K)
    
    func remove(values keys: [D.K])
    
    func wedge(for sieve: Triangle.Sieve) -> D.W
    
    func clean(_ cleaner: Cleaner)
    
    func merge(_ slice: S)
    
    func slice(region triangle: Triangle) -> S?
}

public extension Lattice {
    
    func value(for key: D.K) -> D.V? {
        
        dataStore.value(for: key)
    }
    
    func remove(values keys: [D.K]) {
        
        dataStore.remove(values: keys)
    }
    
    func clean(_ cleaner: Cleaner) {
        
        var emptyRegions: [TriangularRegion<C>] = []
        
        for region in grid.dirtyRegions {
            
            print("Cleaning region")
            
            var emptyChunks: [C] = []
            
            for chunk in region.dirtyChunks {
                
                let wedge = self.wedge(for: chunk.triangle.sieve(for: .chunk))
                
                guard !wedge.isEmpty,
                      cleaner(wedge,
                              chunk) else {
                    
                    emptyChunks.append(chunk)
                    
                    continue
                }
                
                print("Cleaning chunk")
                
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
    
    func propagate(triangle tile: Triangle) {
     
        grid.propagate(triangle: tile)
    }

    func propagate(vertex: Triangle.Vertex) {
        
        grid.propagate(vertex: vertex)
    }
}
