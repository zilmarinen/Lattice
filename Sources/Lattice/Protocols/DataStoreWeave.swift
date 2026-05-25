//
//  DataStoreWeave.swift
//  Lattice
//
//  Created by Zack Brown on 25/05/2026.
//

import Deltille

public struct DataStoreWeave<V: DataStoreValue> {
    
    public let data: [Triangle : DataStoreStitch<V>]
}

public extension DataStoreWeave {

    var isEmpty: Bool {

        data.isEmpty
    }
}

public extension DataStoreWeave {
    
    func value(for key: Triangle) -> DataStoreStitch<V>? {
        
        data[key]
    }
}

public struct DataStoreStitch<V: DataStoreValue> {
    
    public let triangle: Triangle
    public let vertices: [Triangle.Vertex : V]
}
