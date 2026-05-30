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

fileprivate class TriLattice: TriangularLattice<TriLatticeChunk, TriLatticeTile> {}

fileprivate class TriLatticeChunk: TriangularChunk {}

internal struct TriLatticeTile: TriangularDataStoreTile {
    
    internal let vertex: Triangle.Vertex
    
    internal let value: String
    
    internal let footprint: [Triangle.Vertex]
    
    internal var rotation: Triangle.Rotation { .identity }
    
    internal init(vertex: Triangle.Vertex,
                  value: String,
                  footprint: [Triangle.Vertex]? = nil) {
        
        self.vertex = vertex
        self.value = value
        self.footprint = footprint ?? [vertex]
    }
}

@MainActor
final class TriangularLatticeTests: XCTestCase {
    
    // MARK: Lattice
    
    func testValueStorageAndRetrieval() throws {
        
        let lattice = TriLattice()
        
        let value0 = "hex"
        let value1 = "tri"
        
        let triangle0 = Triangle(-14, 26, -12)
        let triangle1 = Triangle(-2, 4, -2)
        
        let vertex0 = triangle0.vertex
        let vertex1 = triangle1.vertex
        
        lattice.set(.init(vertex: vertex0,
                          value: value0),
                    for: triangle0)
        
        lattice.set(.init(vertex: vertex1,
                          value: value1),
                    for: triangle1)
        
        let result0 = lattice.value(for: triangle0)
        let result1 = lattice.value(for: triangle1)
        
        XCTAssertEqual(vertex0, result0?.vertex)
        XCTAssertEqual(value0, result0?.value)
        XCTAssertEqual(vertex1, result1?.vertex)
        XCTAssertEqual(value1, result1?.value)
    }
    
    func testValueDeletion() throws {
        
        let lattice = TriLattice()
        
        let triangle = Triangle(-17, 11, 5)
        
        lattice.set(.init(vertex: triangle.vertex,
                          value: "lattice"),
                    for: triangle)
        
        lattice.remove(values: [triangle])
        
        let regions = lattice.dataStore.regions
        let chunks = regions.flatMap { $0.chunks }
        
        let dirtyRegions = lattice.grid.dirtyRegions
        let dirtyChunks = Set(dirtyRegions.flatMap { $0.dirtyChunks.map { $0.triangle } })
        
        XCTAssertEqual(0, regions.count)
        XCTAssertEqual(0, chunks.count)
        
        XCTAssertEqual(1, dirtyRegions.count)
        XCTAssertEqual(6, dirtyChunks.count)
    }
    
    func testFootprint() throws {
        
        let lattice = TriLattice()
        
        let triangle = Triangle(-82, 58, 23)
        
        lattice.set(.init(vertex: triangle.vertex,
                          value: "lattice",
                          footprint: [triangle.vertex] + triangle.adjacent.map { $0.vertex }),
                    for: triangle)
        
        lattice.remove(values: [triangle])
        
        let regions = lattice.dataStore.regions
        let chunks = regions.flatMap { $0.chunks }
        
        XCTAssertEqual(0, regions.count)
        XCTAssertEqual(0, chunks.count)
    }
    
    func testSoilablePropagation() throws {
        
        let lattice = TriLattice()
        
        let triangle = Triangle(-82, 58, 23)
        let chunk = triangle.transpose(.tile,
                                       .chunk)
        let region = triangle.transpose(.tile,
                                        .region)
        
        lattice.set(.init(vertex: triangle.vertex,
                          value: "lattice"),
                    for: triangle)
        
        let dirtyRegions = lattice.grid.dirtyRegions
        let dirtyChunks = dirtyRegions.flatMap { $0.dirtyChunks }
        
        XCTAssertEqual(1, dirtyRegions.count)
        XCTAssertEqual(region, dirtyRegions.first?.triangle)
        
        XCTAssertEqual(1, dirtyChunks.count)
        XCTAssertEqual(chunk, dirtyChunks.first?.triangle)
    }
    
    func testSoilablePropagationCorner() throws {
        
        let lattice = TriLattice()
        
        let triangle = Triangle(-17, 11, 5)
        let region = triangle.transpose(.tile,
                                        .region)
        
        lattice.set(.init(vertex: triangle.vertex,
                          value: "lattice"),
                    for: triangle)
        
        let chunks = Set(triangle.perimeter.unique(.tile,
                                                   .chunk))
        
        let dirtyRegions = lattice.grid.dirtyRegions
        let dirtyChunks = Set(dirtyRegions.flatMap { $0.dirtyChunks.map { $0.triangle } })
        
        XCTAssertEqual(1, dirtyRegions.count)
        XCTAssertEqual(region, dirtyRegions.first?.triangle)
        
        XCTAssertEqual(6, dirtyChunks.count)
        XCTAssertEqual(chunks, dirtyChunks)
    }
    
    // MARK: Lattice Slice
    
    func testLatticeSlice() throws {
        
        let lattice = TriLattice()
        
        let triangle = Triangle(-17, 11, 5)
        let region = triangle.transpose(.tile,
                                        .region)
        
        lattice.set(.init(vertex: triangle.vertex,
                          value: "lattice"),
                    for: triangle)
        
        let slice = lattice.slice(region: region)
        
        slice?.remove(values: [triangle])
    }
}
