//
//  TriangleDataStoreTests.swift
//  Lattice
//
//  Created by Zack Brown on 11/03/2026.
//

import Deltille
import Euclid
import Testing
@testable import Lattice

private class DataStore: TileDataStore<Value> {}

private struct Value: DataStoreValue {
    
    internal typealias T = Triangle
    
    internal let vertex: Triangle
    
    internal let footprint: Set<Triangle>
    
    internal let value: String
    
    internal init(vertex: Triangle,
                  value: String,
                  footprint: Set<Triangle>? = nil) {
        
        self.vertex = vertex
        self.value = value
        self.footprint = footprint ?? [vertex]
    }
}

@MainActor @Suite
struct TriangleDataStoreTests {
    
    // MARK: Data Store
    
    @Test
    func testValueStorageAndRetrieval() async {
        
        let dataStore = DataStore()
        
        let tile0 = Triangle(-14, 26, -12)
        let tile1 = Triangle(-2, 4, -2)
        
        dataStore.set(.init(vertex: tile0,
                            value: tile0.id))
        
        dataStore.set(.init(vertex: tile1,
                            value: tile1.id))
        
        let result0 = dataStore.value(for: tile0)
        let result1 = dataStore.value(for: tile1)
        
        #expect(tile0 == result0?.vertex)
        #expect(tile0.id == result0?.value)
        #expect(tile1 == result1?.vertex)
        #expect(tile1.id == result1?.value)
    }
    
    @Test
    func testValueDeletion() async {
        
        let dataStore = DataStore()
        
        let tile = Triangle(-17, 11, 5)
        
        let footprint = Set(tile.adjacent + [tile])
        
        dataStore.set(.init(vertex: tile,
                            value: tile.id,
                            footprint: footprint))
        
        dataStore.remove([tile])
        
        let regions = dataStore.regions
        let chunks = regions.flatMap {
            
            $0.chunks
        }
        
        #expect(0 == regions.count)
        #expect(0 == chunks.count)
    }
    
    // MARK: Wedge
    
    @Test
    func testWedge() async {
        
        let dataStore = DataStore()
        
        let tile = Triangle(8, -16, 8)
        let chunk = tile.transpose(.tile,
                                   .chunk)
        
        let footprint = Set(tile.adjacent + [tile])
        
        dataStore.set(.init(vertex: tile,
                            value: tile.id,
                            footprint: footprint))
        
        let wedge = dataStore.wedge(for: chunk.sieve(.chunk))
        
        let tiles = wedge.data.map {
            
            $0.value.vertex
        }
        
        #expect(wedge.data.count == footprint.count)
        #expect(tiles.contains(tile))
        #expect(wedge.value(for: tile)?.value == tile.id)
    }
}
