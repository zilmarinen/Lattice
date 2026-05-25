//
//  DataStoreWedge.swift
//  Lattice
//
//  Created by Zack Brown on 07/03/2026.
//

import Deltille

public struct DataStoreWedge<V: DataStoreValue> {
    
    public let data: [Triangle.Vertex : V]
}

public extension DataStoreWedge {

    var isEmpty: Bool {

        data.isEmpty
    }
}

public extension DataStoreWedge {

    func tiles(_ sieve: Triangle.Sieve) -> [DataStoreWeave<V>] {

        sieve.triangles.reduce(into: [DataStoreWeave<V>]()) { result, triangle in
                    
            let values = triangle.vertices.reduce(into: [Triangle.Vertex : V]()) { result, vertex in
                
                guard let value = data[vertex] else { return }
                
                result[vertex] = value
            }

            guard !values.isEmpty else { return }

            result.append(.init(triangle: triangle,
                                vertices: values))
        }
    }
}

public struct DataStoreWeave<V: DataStoreValue> {
    
    public let triangle: Triangle
    public let vertices: [Triangle.Vertex : V]
}
