//
//  HexagonalDataStoreTests.swift
//  Lattice
//
//  Created by Zack Brown on 11/03/2026.
//

import Deltille
import Euclid
import XCTest
@testable import Lattice

@MainActor
final class HexagonalDataStoreTests: XCTestCase {
    
    // MARK: Data Store
    
    func testValueStorageAndRetrieval() throws {
        
        let dataStore = HexagonalDataStore<HexLatticeTile>()
        
        let value0 = "value0"
        let value1 = "value1"
        
        let vertex0 = Triangle.Vertex(-14, 26, -12)
        let vertex1 = Triangle.Vertex(-2, 4, -2)
        
        dataStore.set(.init(vertex: vertex0,
                            value: value0))
        
        dataStore.set(.init(vertex: vertex1,
                            value: value1))
        
        let result0 = dataStore.value(for: vertex0)
        let result1 = dataStore.value(for: vertex1)
        
        XCTAssertEqual(value0, result0?.value)
        XCTAssertEqual(value1, result1?.value)
    }
    
    func testValueDeletion() throws {
        
        let dataStore = HexagonalDataStore<HexLatticeTile>()
        
        let vertex = Triangle.Vertex(-2, 4, -2)
        
        let footprint = vertex.adjacent + [vertex]
        
        dataStore.set(.init(vertex: vertex,
                            value: "lattice",
                            footprint: footprint))
        
        dataStore.remove([vertex])
        
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
//        let dataStore = HexagonDataStore<HexLatticeTile>()
//
//        let value = "lattice"
//        
//        let hexagon = Hexagon(-82, 58, 23)
//        let chunk = hexagon.transpose(.tile,
//                                      .chunk)
//        
//        dataStore.set(.init(vertex: hexagon,
//                            value: value))
//        
//        let wedge = dataStore.wedge(for: chunk.sieve(.chunk))
//        
//        let tiles = Set(wedge.values.map {
//            
//            $0.value.vertex
//        })
//        
//        XCTAssertEqual(wedge.values.count, 1)
//        XCTAssertTrue(tiles.contains(hexagon))
//        XCTAssertEqual(wedge.value(for: hexagon)?.value, value)
//    }
}
