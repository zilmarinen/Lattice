//
//  DataStoreWedge.swift
//  Lattice
//
//  Created by Zack Brown on 07/03/2026.
//

import Deltille

public struct DataStoreWedge<K: Vertex,
                             V: Codable> {
    
    public let data: [K : V]
}

public extension DataStoreWedge {

    var isEmpty: Bool {

        data.isEmpty
    }
}
