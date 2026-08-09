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

@MainActor
final class TriangleDataStoreTests: XCTestCase {
    
    // MARK: Data Store
    
    func testValueStorageAndRetrieval() throws {
        
        let dataStore = TriangleDataStore<TriLatticeTile>()
        
        let value0 = "value0"
        let value1 = "value1"
        
        let triangle0 = Triangle(-14, 26, -12)
        let triangle1 = Triangle(-2, 4, -2)
        
        dataStore.set(.init(vertex: triangle0,
                            value: value0))
        
        dataStore.set(.init(vertex: triangle1,
                            value: value1))
        
        let result0 = dataStore.value(for: triangle0)
        let result1 = dataStore.value(for: triangle1)
        
        XCTAssertEqual(triangle0, result0?.vertex)
        XCTAssertEqual(value0, result0?.value)
        XCTAssertEqual(triangle1, result1?.vertex)
        XCTAssertEqual(value1, result1?.value)
    }
    
    func testValueDeletion() throws {
        
        let dataStore = TriangleDataStore<TriLatticeTile>()
        
        let triangle = Triangle(-17, 11, 5)
        
        let footprint = triangle.adjacent + [triangle]
        
        dataStore.set(.init(vertex: triangle,
                            value: "lattice",
                            footprint: footprint))
        
        dataStore.remove([triangle])
        
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
//        let dataStore = TriangleDataStore<TriLatticeTile>()
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
