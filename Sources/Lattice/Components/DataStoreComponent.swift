//
//  DataStoreComponent.swift
//  Lattice
//
//  Created by Zack Brown on 07/03/2026.
//

import Deltille

public class DataStoreComponent<V: DataStoreValue>: Codable {
    
    internal enum CodingKeys: CodingKey {
        
        case data
    }
    
    public internal(set) var data: [Coordinate : V]
    
    internal init(values: [V]? = nil) {
        
        let values = values ?? []
        
        self.data = values.reduce(into: [Coordinate : V](), { result, value in
            
            result[value.vertex.position] = value
        })
    }
}

extension DataStoreComponent {
    
    internal var isEmpty: Bool {
        
        data.isEmpty
    }
}
