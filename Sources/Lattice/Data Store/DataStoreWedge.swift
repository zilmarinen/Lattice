//
//  DataStoreWedge.swift
//  Lattice
//
//  Created by Zack Brown on 04/09/2026.
//

import Deltille

public struct DataStoreWedge<K: Coordinate,
                             V: DataStoreValue>: Wedge {
    
    public var data: [K : V]
}
