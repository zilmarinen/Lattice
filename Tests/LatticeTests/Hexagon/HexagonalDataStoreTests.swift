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
    
    internal typealias R = HexagonalDataStoreRegion<HexagonalDataStoreChunk<V>, V>
    internal typealias V = String
    
    // MARK: Data Store
    
    func testValueStorageAndRetrieval() throws {
        
        let dataStore = HexagonalDataStore<R, HexagonalDataStoreChunk<V>, V>()
        
        let value0 = "hex"
        let value1 = "tri"
        
        let triangle0 = Triangle(-14, 26, -12)
        let triangle1 = Triangle(-2, 4, -2)
        
        let vertex0 = triangle0.vertex(.c0)
        let vertex1 = triangle1.vertex(.c0)
        
        dataStore.set(value0,
                      for: vertex0)
        
        dataStore.set(value1,
                      for: vertex1)
        
        let result0 = dataStore.value(for: vertex0)
        let result1 = dataStore.value(for: vertex1)
        
        XCTAssertEqual(value0, result0)
        XCTAssertEqual(value1, result1)
    }
    
    func testWedge() throws {
        
        let dataStore = HexagonalDataStore<R, HexagonalDataStoreChunk<V>, V>()
        
        let value = "lattice"
        
        let triangle = Triangle(-82, 58, 23)
        let chunk = triangle.transpose(.tile,
                                       .chunk)
        
        let vertex = triangle.vertex(.c0)
        
        dataStore.set(value,
                      for: vertex)
        
        let wedge = dataStore.wedge(for: chunk.sieve(for: .chunk))
        
        let vertices = Set(wedge.data.map { $0.value.triangle.vertex })
        
        XCTAssertEqual(wedge.tiles.count, 6)
        XCTAssertEqual(wedge.data.count, 6)
        XCTAssertTrue(vertices.isSubset(of: vertex.tiles.map { $0.vertex }))
    }
}
