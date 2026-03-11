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

internal class HexLattice: HexagonalLattice<HexLatticeChunk, String> {}

internal class HexLatticeChunk: TriangularChunk {}

@MainActor
final class HexagonalLatticeTests: XCTestCase {
    
    internal let lattice = HexLattice()
    
    // MARK: Lattice
    
    func testValueStorage() throws {
        
        let value = "lattice"
        let triangle = Triangle(-14, 26, -12)
        let vertex = triangle.vertex(.c0)
        
        lattice.set(value,
                    for: vertex)
        
        let result = lattice.value(for: vertex)
        
        XCTAssertEqual(value, result)
    }
}
