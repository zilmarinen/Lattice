//
//  ValueStore.swift
//  Lattice
//
//  Created by Zack Brown on 03/08/2026.
//

import Deltille

public class ValueStore<V: DataStoreValue>: Codable {
    
    public internal(set) var data: [V.V : V]
    
    internal init(values: [V]? = nil) {
            
        let values = values ?? []
        
        self.data = values.reduce(into: [V.V : V](), { result, value in
            
            result[value.vertex] = value
        })
    }
}

extension ValueStore {
    
    internal var isEmpty: Bool {
        
        data.isEmpty
    }
}
