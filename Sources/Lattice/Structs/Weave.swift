//
//  Weave.swift
//  Lattice
//
//  Created by Zack Brown on 11/11/2026.
//

import Deltille

public struct Weave<T: Tile,
                    V: DataStoreValue> where T == T.SI.T,
                                             T.V == T.SI.T.V {
    
    public let data: [T : Stitch<T, V>]
}

public extension Weave {
    
    var isEmpty: Bool {
        
        data.isEmpty
    }
}

public extension Weave {
    
    func value(for key: T) -> Stitch<T, V>? {
        
        data[key]
    }
}
