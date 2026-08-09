//
//  HexagonVertexDataStoreTests.swift
//  Lattice
//
//  Created by Zack Brown on 09/08/2026.
//

import Deltille
import Euclid
import XCTest
@testable import Lattice

@MainActor
final class HexagonVertexDataStoreTests: XCTestCase {
    
    // MARK: Data Store
    
    func testValueStorageAndRetrieval() throws {
        
        let dataStore = HexagonVertexDataStore<HexLatticeVertex>()
        
        let value0 = "value0"
        let value1 = "value1"
        
        let hexagon0 = Hexagon(-14, 26, -12)
        let hexagon1 = Hexagon(-2, 4, -2)
        
        let vertex0 = hexagon0.vertex(.c0)
        let vertex1 = hexagon1.vertex(.c1)
        
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
        
        let dataStore = HexagonVertexDataStore<HexLatticeVertex>()
        
        let hexagon = Hexagon(-2, 4, -2)
        
        let vertex = hexagon.vertex(.c0)
        
        dataStore.set(.init(vertex: vertex,
                            value: "lattice"))
        
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
//        let dataStore = HexagonVertexDataStore<HexLatticeVertex>()
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
