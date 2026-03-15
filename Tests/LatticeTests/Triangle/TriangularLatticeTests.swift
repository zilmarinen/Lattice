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
    
    internal let origin: Triangle.Vertex
    internal let value: String
    
    internal var footprint: Triangle.Footprint {
        
        .init(.init(origin),
              [Coordinate.zero])
    }
    
    internal let rotation: Triangle.Rotation?
    
    internal init(origin: Triangle.Vertex,
                  value: String) {
        
        self.origin = origin
        self.value = value
        self.rotation = nil
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
        
        lattice.set(.init(origin: vertex0,
                          value: value0),
                    for: vertex0)
        
        lattice.set(.init(origin: vertex1,
                          value: value1),
                    for: vertex1)
        
        let result0 = lattice.value(for: vertex0)
        let result1 = lattice.value(for: vertex1)
        
        XCTAssertEqual(vertex0, result0?.origin)
        XCTAssertEqual(value0, result0?.value)
        XCTAssertEqual(vertex1, result1?.origin)
        XCTAssertEqual(value1, result1?.value)
    }
    
    func testSoilablePropagation() throws {
        
        let lattice = TriLattice()
        
        let value = "lattice"
        
        let triangle = Triangle(-82, 58, 23)
        let chunk = triangle.transpose(.tile,
                                       .chunk)
        let region = triangle.transpose(.tile,
                                        .region)
        
        let vertex = triangle.vertex
        
        lattice.set(.init(origin: vertex,
                          value: value),
                    for: vertex)
        
        let dirtyRegions = lattice.grid.dirtyRegions
        let dirtyChunks = dirtyRegions.flatMap { $0.dirtyChunks }
        
        XCTAssertEqual(1, dirtyRegions.count)
        XCTAssertEqual(region, dirtyRegions.first?.triangle)
        
        XCTAssertEqual(1, dirtyChunks.count)
        XCTAssertEqual(chunk, dirtyChunks.first?.triangle)
    }
}
