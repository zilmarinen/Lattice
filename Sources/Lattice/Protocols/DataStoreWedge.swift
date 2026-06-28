//
//  DataStoreWedge.swift
//  Lattice
//
//  Created by Zack Brown on 07/03/2026.
//

import Deltille

public struct DataStoreWedge<V: DataStoreValue>: Sendable {
    
    public let data: [Triangle.Vertex : V]
}

public extension DataStoreWedge {

    var isEmpty: Bool {

        data.isEmpty
    }
}

public extension DataStoreWedge {
    
    func value(for key: Triangle.Vertex) -> V? {
        
        data[key]
    }

    func weave(_ sieve: Triangle.Sieve) -> DataStoreWeave<V> {

        let values = sieve.triangles.reduce(into: [Triangle : DataStoreStitch<V>]()) { result, triangle in
                    
            let values = triangle.vertices.reduce(into: [Triangle.Vertex : V]()) { result, vertex in
                
                guard let value = data[vertex] else { return }
                
                result[vertex] = value
            }

            guard !values.isEmpty else { return }

            result[triangle] = .init(triangle: triangle,
                                     vertices: values)
        }
        
        return .init(data: values)
    }
}
