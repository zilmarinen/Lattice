//
//  TriangularLatticeTests.swift
//  Lattice
//
//  Created by Zack Brown on 11/03/2026.
//

import Deltille
import Euclid
import XCTest
@testable import Lattice

//fileprivate class TriLattice: TriangularLattice<TriLatticeChunk, TriLatticeTile> {}
//
//fileprivate class TriLatticeChunk: TriangularChunk {}
//
internal struct TriLatticeTile: DataStoreValue {
    
    internal let vertex: Triangle
    
    internal let footprint: [Triangle]
    
    internal let value: String
    
    internal init(vertex: Triangle,
                  value: String,
                  footprint: [Triangle]? = nil) {
        
        self.vertex = vertex
        self.value = value
        self.footprint = footprint ?? [vertex]
    }
}
//
//internal struct TriLatticeVertex: DataStoreValue {
//    
//    internal let vertex: Triangle.Vertex
//    
//    internal let value: String
//    
//    internal init(vertex: Triangle.Vertex,
//                  value: String) {
//        
//        self.vertex = vertex
//        self.value = value
//    }
//}
//
//@MainActor
//final class TriangularLatticeTests: XCTestCase {
//    
//    // MARK: Lattice
//    
//    func testValueStorageAndRetrieval() throws {
//        
//        let lattice = TriLattice()
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
//        lattice.set(.init(coord: vertex0.position,
//                          value: value0),
//                    for: triangle0)
//        
//        lattice.set(.init(coord: vertex1.position,
//                          value: value1),
//                    for: triangle1)
//        
//        let result0 = lattice.value(for: triangle0)
//        let result1 = lattice.value(for: triangle1)
//        
//        XCTAssertEqual(vertex0.position, result0?.coord)
//        XCTAssertEqual(value0, result0?.value)
//        XCTAssertEqual(vertex1.position, result1?.coord)
//        XCTAssertEqual(value1, result1?.value)
//    }
//    
//    func testValueDeletion() throws {
//        
//        let lattice = TriLattice()
//        
//        let triangle = Triangle(-17, 11, 5)
//        
//        let footprint = (triangle.perimeter + [triangle]).map { $0.vertex.position }
//        
//        lattice.set(.init(coord: triangle.vertex.position,
//                          value: "lattice",
//                          footprint: footprint),
//                    for: triangle)
//        
//        lattice.remove(values: [triangle])
//        
//        let regions = lattice.dataStore.regions
//        let chunks = regions.flatMap { $0.chunks }
//        
//        let dirtyRegions = lattice.grid.dirtyRegions
//        let dirtyChunks = Set(dirtyRegions.flatMap { $0.dirtyChunks.map { $0.tile } })
//        
//        XCTAssertEqual(0, regions.count)
//        XCTAssertEqual(0, chunks.count)
//        
//        XCTAssertEqual(1, dirtyRegions.count)
//        XCTAssertEqual(6, dirtyChunks.count)
//    }
//    
//    func testFootprint() throws {
//        
//        let lattice = TriLattice()
//        
//        let triangle = Triangle(-82, 58, 23)
//        
//        let footprint = (triangle.perimeter + [triangle]).map { $0.vertex.position }
//        
//        lattice.set(.init(coord: triangle.vertex.position,
//                          value: "lattice",
//                          footprint: footprint),
//                    for: triangle)
//        
//        lattice.remove(values: [triangle])
//        
//        let regions = lattice.dataStore.regions
//        let chunks = regions.flatMap { $0.chunks }
//        
//        XCTAssertEqual(0, regions.count)
//        XCTAssertEqual(0, chunks.count)
//    }
//    
//    func testSoilablePropagation() throws {
//        
//        let lattice = TriLattice()
//        
//        let triangle = Triangle(-82, 58, 23)
//        let chunk = triangle.transpose(.tile,
//                                       .chunk)
//        let region = triangle.transpose(.tile,
//                                        .region)
//        
//        lattice.set(.init(coord: triangle.vertex.position,
//                          value: "lattice"),
//                    for: triangle)
//        
//        let dirtyRegions = lattice.grid.dirtyRegions
//        let dirtyChunks = dirtyRegions.flatMap { $0.dirtyChunks }
//        
//        XCTAssertEqual(1, dirtyRegions.count)
//        XCTAssertEqual(region, dirtyRegions.first?.tile)
//        
//        XCTAssertEqual(1, dirtyChunks.count)
//        XCTAssertEqual(chunk, dirtyChunks.first?.tile)
//    }
//    
//    func testSoilablePropagationCorner() throws {
//        
//        let lattice = TriLattice()
//        
//        let triangle = Triangle(-17, 11, 5)
//        let region = triangle.transpose(.tile,
//                                        .region)
//        
//        lattice.set(.init(coord: triangle.vertex.position,
//                          value: "lattice"),
//                    for: triangle)
//        
//        let chunks = Set(triangle.perimeter.unique(.tile,
//                                                   .chunk))
//        
//        let dirtyRegions = lattice.grid.dirtyRegions
//        let dirtyChunks = Set(dirtyRegions.flatMap { $0.dirtyChunks.map { $0.tile } })
//        
//        XCTAssertEqual(1, dirtyRegions.count)
//        XCTAssertEqual(region, dirtyRegions.first?.tile)
//        
//        XCTAssertEqual(6, dirtyChunks.count)
//        XCTAssertEqual(chunks, dirtyChunks)
//    }
//    
//    // MARK: Lattice Slice
//    
//    func testLatticeSlice() throws {
//        
//        let lattice = TriLattice()
//        
//        let triangle = Triangle(-17, 11, 5)
//        let region = triangle.transpose(.tile,
//                                        .region)
//        
//        lattice.set(.init(coord: triangle.vertex.position,
//                          value: "lattice"),
//                    for: triangle)
//        
//        let slice = lattice.slice(region: region)
//        
//        slice?.remove(values: [triangle])
//    }
//}
