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

fileprivate class HexLattice: HexagonalLattice<HexLatticeChunk, String> {}

fileprivate class HexLatticeChunk: TriangularChunk {}

@MainActor
final class HexagonalLatticeTests: XCTestCase {
    
    // MARK: Lattice
    
    func testValueStorageAndRetrieval() throws {
        
        let lattice = HexLattice()
        
        let value0 = "hex"
        let value1 = "tri"
        
        let triangle0 = Triangle(-14, 26, -12)
        let triangle1 = Triangle(-2, 4, -2)
        
        let vertex0 = triangle0.vertex(.c0)
        let vertex1 = triangle1.vertex(.c0)
        
        lattice.set(value0,
                    for: vertex0)
        
        lattice.set(value1,
                    for: vertex1)
        
        let result0 = lattice.value(for: vertex0)
        let result1 = lattice.value(for: vertex1)
        
        XCTAssertEqual(value0, result0)
        XCTAssertEqual(value1, result1)
    }
    
    func testSoilablePropagation() throws {
        
        let lattice = HexLattice()
        
        let value = "lattice"
        
        let triangle = Triangle(-82, 58, 23)
        let chunk = triangle.transpose(.tile,
                                       .chunk)
        let region = triangle.transpose(.tile,
                                        .region)
        
        let vertex = triangle.vertex(.c0)
        
        lattice.set(value,
                    for: vertex)
        
        let dirtyRegions = lattice.grid.dirtyRegions
        let dirtyChunks = dirtyRegions.flatMap { $0.dirtyChunks }
        
        XCTAssertEqual(1, dirtyRegions.count)
        XCTAssertEqual(region, dirtyRegions.first?.triangle)
        
        XCTAssertEqual(1, dirtyChunks.count)
        XCTAssertEqual(chunk, dirtyChunks.first?.triangle)
    }
}
