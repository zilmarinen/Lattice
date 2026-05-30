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
    
    // MARK: Data Store
    
    func testValueStorageAndRetrieval() throws {
        
        let dataStore = TriangularDataStore<R, TriangularDataStoreChunk<V>, V>()
        
        let value0 = "hex"
        let value1 = "tri"
        
        let triangle0 = Triangle(-14, 26, -12)
        let triangle1 = Triangle(-2, 4, -2)
        
        let vertex0 = triangle0.vertex
        let vertex1 = triangle1.vertex
        
        dataStore.set(.init(vertex: vertex0,
                            value: value0),
                      for: triangle0)
        
        dataStore.set(.init(vertex: vertex1,
                            value: value1),
                      for: triangle1)
        
        let result0 = dataStore.value(for: triangle0)
        let result1 = dataStore.value(for: triangle1)
        
        XCTAssertEqual(vertex0, result0?.vertex)
        XCTAssertEqual(value0, result0?.value)
        XCTAssertEqual(vertex1, result1?.vertex)
        XCTAssertEqual(value1, result1?.value)
    }
    
    func testWedge() throws {
        
        let dataStore = TriangularDataStore<R, TriangularDataStoreChunk<V>, V>()
        
        let value = "lattice"
        
        let triangle = Triangle(-82, 58, 23)
        let chunk = triangle.transpose(.tile,
                                       .chunk)
        
        let vertex = triangle.vertex
        
        dataStore.set(.init(vertex: vertex,
                            value: value),
                      for: triangle)
        
        let wedge = dataStore.wedge(for: chunk.sieve(for: .chunk))
        
        let vertices = wedge.data.map { $0.value.vertex }
        
        XCTAssertEqual(wedge.data.count, 1)
        XCTAssertTrue(vertices.contains(vertex))
        XCTAssertEqual(wedge.value(for: vertex)?.value, value)
    }
}
