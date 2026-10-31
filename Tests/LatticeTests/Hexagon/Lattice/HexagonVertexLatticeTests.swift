//
//  HexagonVertexLatticeTests.swift
//  Lattice
//
//  Created by Zack Brown on 28/08/2026.
//

import Deltille
import Euclid
import Testing
@testable import Lattice

private class Lattice: VertexLattice<Chunk, Value> {}

private class Chunk: TileChunk<Hexagon> {}

private struct Value: DataStoreValue {
    
    internal typealias T = Triangle
    
    internal let vertex: Hexagon.Vertex
    
    internal let footprint: Set<Hexagon.Vertex>
    
    internal let value: String
    
    internal init(vertex: Hexagon.Vertex,
                  value: String,
                  footprint: Set<Hexagon.Vertex>? = nil) {
        
        self.vertex = vertex
        self.value = value
        self.footprint = footprint ?? [vertex]
    }
}

@MainActor @Suite
struct HexagonVertexLatticeTests {
    
    // MARK: Data Store
    
    @Test
    func testValueStorageAndRetrieval() async {
        
        let lattice = Lattice()
        
        let vertex0 = Hexagon.Vertex(-6, 10, -5)
        let vertex1 = Hexagon.Vertex(24, -13, -12)
        
        lattice.set(.init(vertex: vertex0,
                          value: vertex0.id))
        
        lattice.set(.init(vertex: vertex1,
                          value: vertex1.id))
        
        let result0 = lattice.value(for: vertex0)
        let result1 = lattice.value(for: vertex1)
        
        #expect(vertex0 == result0?.vertex)
        #expect(vertex0.id == result0?.value)
        #expect(vertex1 == result1?.vertex)
        #expect(vertex1.id == result1?.value)
    }
    
    @Test
    func testValueDeletion() async {
        
        let lattice = Lattice()
        
        let vertex = Hexagon.Vertex(-13, 10, 4)
        
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
        
        #expect(0 == regions.count)
        #expect(0 == chunks.count)
        
        #expect(1 == dirtyRegions.count)
        #expect(1 == dirtyChunks.count)
    }
    
    // MARK: Lattice Slice
    
    @Test
    func testLatticeSlice() async {
        
        let lattice = Lattice()
        
        let vertex = Hexagon.Vertex(-13, 10, 4)
        let tile = Hexagon(-13, 9, 4)
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
        
        #expect(slice?.region.tile == region)
        #expect(values.count == footprint.count)
        #expect(vertices.contains(vertex))
    }
}
