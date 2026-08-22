//
//  HexagonalLatticeTests.swift
//  Lattice
//
//  Created by Zack Brown on 11/03/2026.
//

import Deltille
import Euclid
import XCTest
@testable import Lattice

//fileprivate class HexLattice: HexagonalLattice<HexLatticeChunk, HexLatticeVertex> {}
//
//fileprivate class HexLatticeChunk: TriangularChunk {}
//
internal struct HexLatticeTile: DataStoreValue {
    
    internal let vertex: Triangle.Vertex
    
    internal let footprint: [Triangle.Vertex]
    
    internal let value: String
    
    internal init(vertex: Triangle.Vertex,
                  value: String,
                  footprint: [Triangle.Vertex]? = nil) {
        
        self.vertex = vertex
        self.value = value
        self.footprint = footprint ?? [vertex]
    }
}
//
//internal struct HexLatticeVertex: DataStoreValue {
//    
//    internal let vertex: Hexagon.Vertex
//    
//    internal let value: String
//    
//    internal init(vertex: Hexagon.Vertex,
//                  value: String) {
//        
//        self.vertex = vertex
//        self.value = value
//    }
//}
//
//@MainActor
//final class HexagonalLatticeTests: XCTestCase {
//    
//    // MARK: Lattice
//    
//    func testValueStorageAndRetrieval() throws {
//        
//        let lattice = HexLattice()
//        
//        let value0 = "hex"
//        let value1 = "tri"
//        
//        let triangle0 = Triangle(-14, 26, -12)
//        let triangle1 = Triangle(-2, 4, -2)
//        
//        let vertex0 = triangle0.vertex(.c0)
//        let vertex1 = triangle1.vertex(.c0)
//        
//        lattice.set(.init(coord: vertex0.position,
//                          value: value0),
//                    for: vertex0)
//        
//        lattice.set(.init(coord: vertex1.position,
//                          value: value1),
//                    for: vertex1)
//        
//        let result0 = lattice.value(for: vertex0)
//        let result1 = lattice.value(for: vertex1)
//        
//        XCTAssertEqual(value0, result0?.value)
//        XCTAssertEqual(value1, result1?.value)
//    }
//    
//    func testValueDeletion() throws {
//        
//        let lattice = HexLattice()
//        
//        let vertex = Triangle.Vertex(-16, 12, 5)
//        
//        lattice.set(.init(coord: vertex.position,
//                          value: "lattice"),
//                    for: vertex)
//        
//        lattice.remove(values: [vertex])
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
//    func testSoilablePropagation() throws {
//        
//        let lattice = HexLattice()
//        
//        let triangle = Triangle(-82, 58, 23)
//        let chunk = triangle.transpose(.tile,
//                                       .chunk)
//        let region = triangle.transpose(.tile,
//                                        .region)
//        
//        let vertex = triangle.vertex(.c0)
//        
//        lattice.set(.init(coord: vertex.position,
//                          value: "lattice"),
//                    for: vertex)
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
//        let lattice = HexLattice()
//        
//        let vertex = Triangle.Vertex(-16, 12, 5)
//        
//        lattice.set(.init(coord: vertex.position,
//                          value: "lattice"),
//                    for: vertex)
//        
//        let regions = Set(vertex.tiles.unique(.tile,
//                                              .region))
//        let chunks = Set(vertex.tiles.unique(.tile,
//                                             .chunk))
//        
//        let dirtyRegions = lattice.grid.dirtyRegions
//        let dirtyChunks = Set(dirtyRegions.flatMap { $0.dirtyChunks.map { $0.tile } })
//        
//        XCTAssertEqual(1, dirtyRegions.count)
//        XCTAssertEqual(regions.first, dirtyRegions.first?.tile)
//        
//        XCTAssertEqual(6, dirtyChunks.count)
//        XCTAssertEqual(chunks, dirtyChunks)
//    }
//    
//    // MARK: Lattice Slice
//    
//    func testLatticeSlice() throws {
//        
//        let lattice = HexLattice()
//        
//        let vertex = Triangle.Vertex(-16, 12, 5)
//        
//        let triangle = vertex.tiles.first!
//        
//        lattice.set(.init(coord: vertex.position,
//                          value: "lattice"),
//                    for: vertex)
//        
//        let slice = lattice.slice(region: triangle.transpose(.tile,
//                                                             .region))
//        
//        slice?.remove(values: [vertex])
//    }
//}
