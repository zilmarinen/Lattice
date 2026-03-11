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
    
    internal let dataStore = HexagonalDataStore<R, HexagonalDataStoreChunk<V>, V>()
    
    // MARK: Data Store
    
    func testValueStorage() throws {
        
        let value = "lattice"
        let triangle = Triangle(-14, 26, -12)
        let vertex = triangle.vertex(.c0)
        
        dataStore.set(value,
                      for: vertex)
        
        let result = dataStore.value(for: vertex)
        
        XCTAssertEqual(value, result)
    }
}
