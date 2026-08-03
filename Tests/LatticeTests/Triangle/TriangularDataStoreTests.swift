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

//@MainActor
//final class TriangularDataStoreTests: XCTestCase {
//    
//    internal typealias R = TriangularDataStoreRegion<TriangularDataStoreChunk<V>, V>
//    internal typealias V = TriLatticeTile
//    
//    // MARK: Data Store
//    
//    func testValueStorageAndRetrieval() throws {
//        
//        let dataStore = TriangularDataStore<R, TriangularDataStoreChunk<V>, V>()
//        
//        let value0 = "hex"
//        let value1 = "tri"
//        
//        let triangle0 = Triangle(-14, 26, -12)
//        let triangle1 = Triangle(-2, 4, -2)
//        
//        let vertex0 = triangle0.vertex
//        let vertex1 = triangle1.vertex
//        
//        dataStore.set(.init(coord: vertex0.position,
//                            value: value0),
//                      for: triangle0)
//        
//        dataStore.set(.init(coord: vertex1.position,
//                            value: value1),
//                      for: triangle1)
//        
//        let result0 = dataStore.value(for: triangle0)
//        let result1 = dataStore.value(for: triangle1)
//        
//        XCTAssertEqual(vertex0.position, result0?.coord)
//        XCTAssertEqual(value0, result0?.value)
//        XCTAssertEqual(vertex1.position, result1?.coord)
//        XCTAssertEqual(value1, result1?.value)
//    }
//    
//    func testValueDeletion() throws {
//        
//        let dataStore = TriangularDataStore<R, TriangularDataStoreChunk<V>, V>()
//        
//        let triangle = Triangle(-17, 11, 5)
//        
//        let footprint = (triangle.perimeter + [triangle]).map { $0.vertex.position }
//        
//        dataStore.set(.init(coord: triangle.vertex.position,
//                            value: "lattice",
//                            footprint: footprint),
//                      for: triangle)
//        
//        dataStore.remove(values: [triangle])
//        
//        let regions = dataStore.regions
//        let chunks = regions.flatMap { $0.chunks }
//        
//        XCTAssertEqual(0, regions.count)
//        XCTAssertEqual(0, chunks.count)
//    }
//    
//    // MARK: Wedge
//    
//    func testWedge() throws {
//        
//        let dataStore = TriangularDataStore<R, TriangularDataStoreChunk<V>, V>()
//        
//        let value = "lattice"
//        
//        let triangle = Triangle(-82, 58, 23)
//        let chunk = triangle.transpose(.tile,
//                                       .chunk)
//        
//        let vertex = triangle.vertex
//        
//        let footprint = (triangle.perimeter + [triangle]).map { $0.vertex.position }
//        
//        dataStore.set(.init(coord: vertex.position,
//                            value: value,
//                            footprint: footprint),
//                      for: triangle)
//        
//        let wedge = dataStore.wedge(for: chunk.sieve(for: .chunk))
//        
//        let vertices = wedge.data.map { $0.value.coord }
//        
//        XCTAssertEqual(wedge.data.count, footprint.count)
//        XCTAssertTrue(vertices.contains(vertex.position))
//        XCTAssertEqual(wedge.value(for: vertex)?.value, value)
//    }
//}
