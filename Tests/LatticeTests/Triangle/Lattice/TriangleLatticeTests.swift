//
//  TriangleLatticeTests.swift
//  Lattice
//
//  Created by Zack Brown on 11/03/2026.
//

import Deltille
import Euclid
import XCTest
@testable import Lattice

fileprivate class Lattice: TileLattice<Chunk, Triangle, Tile> {}

fileprivate class Chunk: GridChunk<Triangle> {}

fileprivate struct Tile: DataStoreValue {
    
    internal let vertex: Triangle
    
    internal let footprint: Set<Triangle>
    
    internal let value: String
    
    internal init(vertex: Triangle,
                  value: String,
                  footprint: Set<Triangle>? = nil ) {
        
        self.vertex = vertex
        self.value = value
        self.footprint = footprint ?? [vertex]
    }
}

@MainActor
final class TriangleLatticeTests: XCTestCase {

    // MARK: Lattice
    
    func testValueStorageAndRetrieval() throws {
        
        let lattice = Lattice()
        
        let tile0 = Triangle(-14, 26, -12)
        let tile1 = Triangle(-2, 4, -2)
        
        lattice.set(.init(vertex: tile0,
                          value: tile0.id))
        
        lattice.set(.init(vertex: tile1,
                          value: tile1.id))
        
        let result0 = lattice.value(for: tile0)
        let result1 = lattice.value(for: tile1)
        
        XCTAssertEqual(tile0, result0?.vertex)
        XCTAssertEqual(tile0.id, result0?.value)
        XCTAssertEqual(tile1, result1?.vertex)
        XCTAssertEqual(tile1.id, result1?.value)
    }
    
    func testValueDeletion() throws {
        
        let lattice = Lattice()
        
        let tile = Triangle(-17, 11, 5)
        
        let footprint = Set(tile.adjacent + [tile])
        
        lattice.set(.init(vertex: tile,
                          value: tile.id,
                          footprint: footprint))
        
        lattice.remove([tile])
        
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
    
    func testSoilablePropagation() throws {
        
        let lattice = Lattice()
        
        let tile = Triangle(-21, 11, 10)
        let chunk = tile.transpose(.tile,
                                   .chunk)
        let region = tile.transpose(.tile,
                                    .region)
        
        lattice.set(.init(vertex: tile,
                          value: tile.id))
        
        let dirtyRegions = lattice.grid.dirtyRegions
        let dirtyChunks = dirtyRegions.flatMap {
            
            $0.dirtyChunks
        }
        
        XCTAssertEqual(1, dirtyRegions.count)
        XCTAssertEqual(region, dirtyRegions.first?.tile)
        
        XCTAssertEqual(1, dirtyChunks.count)
        XCTAssertEqual(chunk, dirtyChunks.first?.tile)
    }
    
    func testFootprint() throws {
        
        let lattice = Lattice()
        
        let tile = Triangle(-21, 11, 10)
        
        let footprint = Set(tile.adjacent + [tile])
        
        lattice.set(.init(vertex: tile,
                          value: tile.id,
                          footprint: footprint))
        
        lattice.remove([tile])
        
        let regions = lattice.store.regions
        let chunks = regions.flatMap {
            
            $0.chunks
        }
        
        XCTAssertEqual(0, regions.count)
        XCTAssertEqual(0, chunks.count)
    }
    
    // MARK: Lattice Slice
    
    func testLatticeSlice() throws {
        
        let lattice = Lattice()
        
        let tile = Triangle(8, -16, 8)
        let region = tile.transpose(.tile,
                                    .region)
        
        let footprint = Set(tile.adjacent + [tile])
        
        lattice.set(.init(vertex: tile,
                          value: tile.id,
                          footprint: footprint))
        
        let slice = lattice.slice(for: region)
        
        let tiles = slice?.chunks.flatMap {
            
            $0.data.keys
            
        } ?? []
        
        let values = slice?.chunks.flatMap {
            
            $0.data.values
            
        } ?? []
        
        XCTAssertEqual(slice?.region.tile, region)
        XCTAssertEqual(values.count, footprint.count)
        XCTAssertTrue(tiles.contains(tile))
    }
}
