//
//  HexagonVertexLatticeTests.swift
//  Lattice
//
//  Created by Zack Brown on 28/08/2026.
//

import Deltille
import Euclid
import XCTest
@testable import Lattice

fileprivate class Lattice: VertexLattice<Chunk, Triangle, Tile> {}

fileprivate class Chunk: GridChunk<Triangle> {}

fileprivate struct Tile: DataStoreValue {
    
    internal let vertex: Hexagon.Vertex
    
    internal let footprint: Set<Hexagon.Vertex>
    
    internal let value: String
    
    internal init(vertex: Hexagon.Vertex,
                  value: String,
                  footprint: Set<Hexagon.Vertex>? = nil ) {
        
        self.vertex = vertex
        self.value = value
        self.footprint = footprint ?? [vertex]
    }
}

@MainActor
final class HexagonVertexLatticeTests: XCTestCase {
    
    // MARK: Data Store
    
    func testValueStorageAndRetrieval() throws {
        
        let lattice = Lattice()
        
        let vertex0 = Hexagon.Vertex(-6, 10, -5)
        let vertex1 = Hexagon.Vertex(24, -13, -12)
        
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
        
        let vertex = Hexagon.Vertex(-7, -14, 20)
        
        let footprint = Set(vertex.vertices + [vertex])
        
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
    
    func testLatticeSlice() throws {
        
        let lattice = Lattice()
        
        let vertex = Hexagon.Vertex(15, -6, -10)
        let tile = Triangle(vertex.vector(),
                            2.0)
        let region = tile.transpose(.tile,
                                    .region)
        
        let footprint = Set(vertex.vertices + [vertex])
        
        lattice.set(.init(vertex: vertex,
                          value: vertex.id,
                          footprint: footprint))
        
        let slice = lattice.slice(for: region)
        
        let vertices = slice?.chunks.flatMap {
            
            $0.data.keys
            
        } ?? []
        
        let values = slice?.chunks.flatMap {
            
            $0.data.values
            
        } ?? []
        
        XCTAssertEqual(slice?.region.tile, region)
        XCTAssertEqual(values.count, footprint.count)
        XCTAssertTrue(vertices.contains(vertex))
    }
}
