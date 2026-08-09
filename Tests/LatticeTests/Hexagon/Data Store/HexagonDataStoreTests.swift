//
//  HexagonDataStoreTests.swift
//  Lattice
//
//  Created by Zack Brown on 11/03/2026.
//

import Deltille
import Euclid
import XCTest
@testable import Lattice

@MainActor
final class HexagonDataStoreTests: XCTestCase {
    
    // MARK: Data Store
    
    func testValueStorageAndRetrieval() throws {
        
        let dataStore = HexagonDataStore<HexLatticeTile>()
        
        let value0 = "value0"
        let value1 = "value1"
        
        let hexagon0 = Hexagon(-14, 26, -12)
        let hexagon1 = Hexagon(-2, 4, -2)
        
        dataStore.set(.init(vertex: hexagon0,
                            value: value0))
        
        dataStore.set(.init(vertex: hexagon1,
                            value: value1))
        
        let result0 = dataStore.value(for: hexagon0)
        let result1 = dataStore.value(for: hexagon1)
        
        XCTAssertEqual(value0, result0?.value)
        XCTAssertEqual(value1, result1?.value)
    }
    
    func testValueDeletion() throws {
        
        let dataStore = HexagonDataStore<HexLatticeTile>()
        
        let hexagon = Hexagon(-2, 4, -2)
        
        let footprint = hexagon.adjacent + [hexagon]
        
        dataStore.set(.init(vertex: hexagon,
                            value: "lattice",
                            footprint: footprint))
        
        dataStore.remove([hexagon])
        
        XCTAssertEqual(0, dataStore.chunks.count)
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
