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
    internal typealias V = HexLatticeVertex
    
    // MARK: Data Store
    
    func testValueStorageAndRetrieval() throws {
        
        let dataStore = HexagonalDataStore<R, HexagonalDataStoreChunk<V>, V>()
        
        let value0 = "hex"
        let value1 = "tri"
        
        let triangle0 = Triangle(-14, 26, -12)
        let triangle1 = Triangle(-2, 4, -2)
        
        let vertex0 = triangle0.vertex(.c0)
        let vertex1 = triangle1.vertex(.c0)
        
        dataStore.set(.init(vertex: vertex0,
                            value: value0),
                      for: vertex0)
        
        dataStore.set(.init(vertex: vertex1,
                            value: value1),
                      for: vertex1)
        
        let result0 = dataStore.value(for: vertex0)
        let result1 = dataStore.value(for: vertex1)
        
        XCTAssertEqual(value0, result0?.value)
        XCTAssertEqual(value1, result1?.value)
    }
    
    func testWedge() throws {
        
        let dataStore = HexagonalDataStore<R, HexagonalDataStoreChunk<V>, V>()
        
        let value = "lattice"
        
        let triangle = Triangle(-82, 58, 23)
        let chunk = triangle.transpose(.tile,
                                       .chunk)
        
        let vertex = triangle.vertex(.c0)
        
        dataStore.set(.init(vertex: vertex,
                            value: value),
                      for: vertex)
        
        let wedge = dataStore.wedge(for: chunk.sieve(for: .chunk))
        
        let vertices = Set(wedge.data.map { $0.value.vertex })
        
        XCTAssertEqual(wedge.data.count, 1)
        XCTAssertTrue(vertices.contains(vertex))
    }
}
