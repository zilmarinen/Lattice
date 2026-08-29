//
//  TriangleVertexDataStoreTests.swift
//  Lattice
//
//  Created by Zack Brown on 28/08/2026.
//

import Deltille
import Euclid
import XCTest
@testable import Lattice

fileprivate class DataStore: TriangleVertexDataStore<TriangleVertexDataStoreTile> {}

fileprivate struct TriangleVertexDataStoreTile: DataStoreValue {
    
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
final class TriangleVertexDataStoreTests: XCTestCase {
    
    // MARK: Data Store
    
    func testValueStorageAndRetrieval() throws {
        
        let dataStore = DataStore()
        
        let vertex0 = Triangle.Vertex(-15, 17, -1)
        let vertex1 = Triangle.Vertex(6, -12, 7)
        
        dataStore.set(.init(vertex: vertex0,
                            value: vertex0.id))
        
        dataStore.set(.init(vertex: vertex1,
                            value: vertex1.id))
        
        let result0 = dataStore.value(for: vertex0)
        let result1 = dataStore.value(for: vertex1)
        
        XCTAssertEqual(vertex0.id, result0?.value)
        XCTAssertEqual(vertex1.id, result1?.value)
    }
    
    func testValueDeletion() throws {
        
        let dataStore = DataStore()
        
        let vertex = Triangle.Vertex(6, -12, 7)
        
        let footprint = Set(vertex.adjacent + [vertex])
        
        dataStore.set(.init(vertex: vertex,
                            value: vertex.id,
                            footprint: footprint))
        
        dataStore.remove([vertex])
        
        let regions = dataStore.regions
        let chunks = regions.flatMap {
            
            $0.chunks
        }
        
        XCTAssertEqual(0, regions.count)
        XCTAssertEqual(0, chunks.count)
    }
    
    // MARK: Wedge
    
//    func testWedge() throws {
//
//        let dataStore = DataStore()
//
//        let value = "lattice"
//
//        let hexagon = Hexagon(-82, 58, 23)
//        let chunk = hexagon.transpose(.tile,
//                                      .chunk)
//
//        dataStore.set(.init(vertex: hexagon,
//                            value: value))
//
//        let wedge = dataStore.wedge(for: chunk.sieve(.chunk))
//
//        let tiles = Set(wedge.values.map {
//
//            $0.value.vertex
//        })
//
//        XCTAssertEqual(wedge.values.count, 1)
//        XCTAssertTrue(tiles.contains(hexagon))
//        XCTAssertEqual(wedge.value(for: hexagon)?.value, value)
//    }
}
