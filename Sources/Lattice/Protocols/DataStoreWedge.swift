//
//  DataStoreWedge.swift
//  Lattice
//
//  Created by Zack Brown on 03/08/2026.
//

import Deltille

public struct DataStoreWedge<T: DataStoreTile>: Sendable {
    
    public let values: [T.V : T]
}

public extension DataStoreWedge {
    
    var isEmpty: Bool {
    
        values.isEmpty
    }
}

public extension DataStoreWedge {
    
    func value(for key: T.V) -> T? {
        
        values[key]
    }
}
