//
//  TriangleDataStoreTests.swift
//  Lattice
//
//  Created by Zack Brown on 11/03/2026.
//

import Deltille
import Euclid
import XCTest
@testable import Lattice

fileprivate class DataStore: TileDataStore<Triangle, Tile> {}

fileprivate struct Tile: DataStoreValue {
    
    internal let vertex: Triangle
    
    internal let footprint: Set<Triangle>
    
    internal let value: String
    
    internal init(vertex: Triangle,
                  value: String,
                  footprint: Set<Triangle>? = nil ) {
        
        self.vertex = vertex
        self.value = value
        self.footprint = footprint ?? [vertex]
    }
}

@MainActor
final class TriangleDataStoreTests: XCTestCase {
    
    // MARK: Data Store
    
    func testValueStorageAndRetrieval() throws {
        
        let dataStore = DataStore()
        
        let tile0 = Triangle(-14, 26, -12)
        let tile1 = Triangle(-2, 4, -2)
        
        dataStore.set(.init(vertex: tile0,
                            value: tile0.id))
        
        dataStore.set(.init(vertex: tile1,
                            value: tile1.id))
        
        let result0 = dataStore.value(for: tile0)
        let result1 = dataStore.value(for: tile1)
        
        XCTAssertEqual(tile0, result0?.vertex)
        XCTAssertEqual(tile0.id, result0?.value)
        XCTAssertEqual(tile1, result1?.vertex)
        XCTAssertEqual(tile1.id, result1?.value)
    }
    
    func testValueDeletion() throws {
        
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
        
        XCTAssertEqual(0, regions.count)
        XCTAssertEqual(0, chunks.count)
    }
    
    // MARK: Wedge
    
//    func testWedge() throws {
//        
//        let dataStore = DataStore()
//
//        let value = "lattice"
//        
//        let triangle = Triangle(-82, 58, 23)
//        let chunk = triangle.transpose(.tile,
//                                       .chunk)
//        
//        let footprint = triangle.adjacent + [triangle]
//        
//        dataStore.set(.init(vertex: triangle,
//                            value: value,
//                            footprint: footprint))
//        
//        let wedge = dataStore.wedge(for: chunk.sieve(.chunk))
//        
//        let tiles = wedge.values.map {
//            
//            $0.value.vertex
//        }
//        
//        XCTAssertEqual(wedge.values.count, footprint.count)
//        XCTAssertTrue(tiles.contains(triangle))
//        XCTAssertEqual(wedge.value(for: triangle)?.value, value)
//    }
}
