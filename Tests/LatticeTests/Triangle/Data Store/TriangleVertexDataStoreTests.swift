//
//  TriangleVertexDataStoreTests.swift
//  Lattice
//
//  Created by Zack Brown on 09/08/2026.
//

import Deltille
import Euclid
import XCTest
@testable import Lattice

@MainActor
final class TriangleVertexDataStoreTests: XCTestCase {
    
    // MARK: Data Store
    
    func testValueStorageAndRetrieval() throws {
        
        let dataStore = TriangleVertexDataStore<TriLatticeVertex>()
        
        let value0 = "value0"
        let value1 = "value1"
        
        let triangle0 = Triangle(-14, 26, -12)
        let triangle1 = Triangle(-2, 4, -2)
        
        let vertex0 = triangle0.vertex(.c0)
        let vertex1 = triangle1.vertex(.c1)
        
        dataStore.set(.init(vertex: vertex0,
                            value: value0))
        
        dataStore.set(.init(vertex: vertex1,
                            value: value1))
        
        let result0 = dataStore.value(for: vertex0)
        let result1 = dataStore.value(for: vertex1)
        
        XCTAssertEqual(vertex0, result0?.vertex)
        XCTAssertEqual(value0, result0?.value)
        XCTAssertEqual(vertex1, result1?.vertex)
        XCTAssertEqual(value1, result1?.value)
    }
    
    func testValueDeletion() throws {
        
        let dataStore = TriangleVertexDataStore<TriLatticeVertex>()
        
        let triangle = Triangle(-17, 11, 5)
        
        let vertex = triangle.vertex(.c0)
        
        dataStore.set(.init(vertex: vertex,
                            value: "lattice"))
        
        dataStore.remove([vertex])
        
        XCTAssertEqual(0, dataStore.chunks.count)
    }
    
    // MARK: Wedge
    
//    func testWedge() throws {
//        
//        let dataStore = TriangleVertexDataStore<TriLatticeVertex>()
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
