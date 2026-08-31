//
//  TriangleVertexLatticeTests.swift
//  Lattice
//
//  Created by Zack Brown on 28/08/2026.
//

import Deltille
import Euclid
import XCTest
@testable import Lattice

fileprivate class Lattice: VertexLattice<Chunk, Hexagon, Tile> {}

fileprivate class Chunk: GridChunk<Hexagon> {}

fileprivate struct Tile: DataStoreValue {
    
    internal let vertex: Triangle.Vertex
    
    internal let footprint: Set<Triangle.Vertex>
    
    internal let value: String
    
    internal init(vertex: Triangle.Vertex,
                  value: String,
                  footprint: Set<Triangle.Vertex>? = nil ) {
        
        self.vertex = vertex
        self.value = value
        self.footprint = footprint ?? [vertex]
    }
}

@MainActor
final class TriangleVertexLatticeTests: XCTestCase {
    
    // MARK: Data Store
    
    func testValueStorageAndRetrieval() throws {
        
        let lattice = Lattice()
        
        let vertex0 = Triangle.Vertex(-15, 17, -1)
        let vertex1 = Triangle.Vertex(6, -12, 7)
        
        lattice.set(.init(vertex: vertex0,
                          value: vertex0.id))
        
        lattice.set(.init(vertex: vertex1,
                          value: vertex1.id))
        
        let result0 = lattice.value(for: vertex0)
        let result1 = lattice.value(for: vertex1)
        
        XCTAssertEqual(vertex0, result0?.vertex)
        XCTAssertEqual(vertex0.id, result0?.value)
        XCTAssertEqual(vertex1, result1?.vertex)
        XCTAssertEqual(vertex1.id, result1?.value)
    }
    
    func testValueDeletion() throws {
        
        let lattice = Lattice()
        
        let vertex = Triangle.Vertex(6, -12, 7)
        
        let footprint = Set(vertex.adjacent + [vertex])
        
        lattice.set(.init(vertex: vertex,
                          value: vertex.id,
                          footprint: footprint))
        
        lattice.remove([vertex])
        
        let regions = lattice.store.regions
        let chunks = regions.flatMap {
            
            $0.chunks
        }
        
        let dirtyRegions = lattice.grid.dirtyRegions
        let dirtyChunks = Set(dirtyRegions.flatMap {
            
            $0.dirtyChunks.map {
                
                $0.tile
            }
        })
        
        XCTAssertEqual(0, regions.count)
        XCTAssertEqual(0, chunks.count)
        
        XCTAssertEqual(1, dirtyRegions.count)
        XCTAssertEqual(1, dirtyChunks.count)
    }
    
    // MARK: Lattice Slice
    
//    func testLatticeSlice() throws {
//
//        let lattice = Lattice()
//
//        let tile = Triangle(-17, 11, 5)
//        let region = tile.transpose(.tile,
//                                    .region)
//
//        lattice.set(.init(vertex: tile,
//                          value: tile.id)
//
//        let slice = lattice.slice(region: region)
//
//        slice?.remove(values: [triangle])
//    }
}
