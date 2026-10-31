//
//  TriangleVertexDataStoreTests.swift
//  Lattice
//
//  Created by Zack Brown on 28/08/2026.
//

import Deltille
import Euclid
import Testing
@testable import Lattice

private class DataStore: VertexDataStore<Value> {}

private struct Value: DataStoreValue {
    
    internal typealias T = Hexagon
    
    internal let vertex: Triangle.Vertex
    
    internal let footprint: Set<Triangle.Vertex>
    
    internal let value: String
    
    internal init(vertex: Triangle.Vertex,
                  value: String,
                  footprint: Set<Triangle.Vertex>? = nil) {
        
        self.vertex = vertex
        self.value = value
        self.footprint = footprint ?? [vertex]
    }
}

@MainActor @Suite
struct TriangleVertexDataStoreTests {
    
    // MARK: Data Store
    
    @Test
    func testValueStorageAndRetrieval() async {
        
        let dataStore = DataStore()
        
        let vertex0 = Triangle.Vertex(-15, 17, -1)
        let vertex1 = Triangle.Vertex(6, -12, 7)
        
        dataStore.set(.init(vertex: vertex0,
                            value: vertex0.id))
        
        dataStore.set(.init(vertex: vertex1,
                            value: vertex1.id))
        
        let result0 = dataStore.value(for: vertex0)
        let result1 = dataStore.value(for: vertex1)
        
        #expect(vertex0.id == result0?.value)
        #expect(vertex1.id == result1?.value)
    }
    
    @Test
    func testValueDeletion() async {
        
        let dataStore = DataStore()
        
        let vertex = Triangle.Vertex(8, -15, 8)
        
        let footprint = Set(vertex.vertices + [vertex])
        
        dataStore.set(.init(vertex: vertex,
                            value: vertex.id,
                            footprint: footprint))
        
        dataStore.remove([vertex])
        
        let regions = dataStore.regions
        let chunks = regions.flatMap {
            
            $0.chunks
        }
        
        #expect(0 == regions.count)
        #expect(0 == chunks.count)
    }
    
    // MARK: Wedge
    
    @Test
    func testWedge() async {

        let dataStore = DataStore()

        let tile = Triangle(8, -16, 8)
        let vertex = Triangle.Vertex(8, -15, 8)
        let chunk = tile.transpose(.tile,
                                   .chunk)
        
        let footprint = Set(vertex.vertices + [vertex])
        
        dataStore.set(.init(vertex: vertex,
                            value: vertex.id,
                            footprint: footprint))
        
        let wedge = dataStore.wedge(for: chunk.sieve(.chunk))

        let vertices = Set(wedge.data.map {

            $0.value.vertex
        })

        #expect(wedge.data.count == footprint.count)
        #expect(vertices.contains(vertex))
        #expect(wedge.value(for: vertex)?.value == vertex.id)
    }
}
