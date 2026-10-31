//
//  TriangleLatticeTests.swift
//  Lattice
//
//  Created by Zack Brown on 11/03/2026.
//

import Deltille
import Euclid
import Testing
@testable import Lattice

private class Lattice: TileLattice<Chunk, Value> {}

private class Chunk: TileChunk<Triangle> {}

private struct Value: DataStoreValue {
    
    internal typealias T = Triangle
    
    internal let vertex: Triangle
    
    internal let footprint: Set<Triangle>
    
    internal let value: String
    
    internal init(vertex: Triangle,
                  value: String,
                  footprint: Set<Triangle>? = nil) {
        
        self.vertex = vertex
        self.value = value
        self.footprint = footprint ?? [vertex]
    }
}

@MainActor @Suite
struct TriangleLatticeTests {

    // MARK: Lattice
    
    @Test
    func testValueStorageAndRetrieval() async {
        
        let lattice = Lattice()
        
        let tile0 = Triangle(-14, 26, -12)
        let tile1 = Triangle(-2, 4, -2)
        
        lattice.set(.init(vertex: tile0,
                          value: tile0.id))
        
        lattice.set(.init(vertex: tile1,
                          value: tile1.id))
        
        let result0 = lattice.value(for: tile0)
        let result1 = lattice.value(for: tile1)
        
        #expect(tile0 == result0?.vertex)
        #expect(tile0.id == result0?.value)
        #expect(tile1 == result1?.vertex)
        #expect(tile1.id == result1?.value)
    }
    
    @Test
    func testValueDeletion() async {
        
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
        
        #expect(0 == regions.count)
        #expect(0 == chunks.count)
        
        #expect(1 == dirtyRegions.count)
        #expect(1 == dirtyChunks.count)
    }
    
    @Test
    func testSoilablePropagation() async {
        
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
        
        #expect(1 == dirtyRegions.count)
        #expect(region == dirtyRegions.first?.tile)
        
        #expect(1 == dirtyChunks.count)
        #expect(chunk == dirtyChunks.first?.tile)
    }
    
    @Test
    func testFootprint() async {
        
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
        
        #expect(0 == regions.count)
        #expect(0 == chunks.count)
    }
    
    // MARK: Lattice Slice
    
    @Test
    func testLatticeSlice() async {
        
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
        
        #expect(slice?.region.tile == region)
        #expect(values.count == footprint.count)
        #expect(tiles.contains(tile))
    }
}
