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

internal class TriLattice: TriangularLattice<TriLatticeChunk, TriLatticeTile> {}

internal class TriLatticeChunk: TriangularChunk {}

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
    
    internal let lattice = TriLattice()
    
    // MARK: Lattice
    
    func testValueStorage() throws {
        
        let value = "lattice"
        let triangle = Triangle(-14, 26, -12)
        let vertex = triangle.vertex
        
        let tile = TriLatticeTile(origin: vertex,
                                  value: value)
        
        lattice.set(tile,
                    for: vertex)
        
        let result = lattice.value(for: vertex)
        
        XCTAssertEqual(value, result?.value)
    }
}
