//
//  TriangularDataStoreTests.swift
//  Lattice
//
//  Created by Zack Brown on 11/03/2026.
//

import Deltille
import Euclid
import XCTest
@testable import Lattice

@MainActor
final class TriangularDataStoreTests: XCTestCase {
    
    internal typealias R = TriangularDataStoreRegion<TriangularDataStoreChunk<V>, V>
    internal typealias V = TriLatticeTile
    
    internal let dataStore = TriangularDataStore<R, TriangularDataStoreChunk<V>, V>()
    
    // MARK: Data Store
    
    func testValueStorage() throws {
        
        let value = "lattice"
        let triangle = Triangle(-14, 26, -12)
        let vertex = triangle.vertex
        
        let tile = TriLatticeTile(origin: vertex,
                                  value: value)
        
        dataStore.set(tile,
                      for: vertex)
        
        let result = dataStore.value(for: vertex)
        
        XCTAssertEqual(value, result?.value)
    }
}
