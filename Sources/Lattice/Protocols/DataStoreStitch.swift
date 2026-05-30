//
//  DataStoreStitch.swift
//  Lattice
//
//  Created by Zack Brown on 30/05/2026.
//

import Deltille

public struct DataStoreStitch<V: DataStoreValue> {
    
    public let triangle: Triangle
    public let vertices: [Triangle.Vertex : V]
}
