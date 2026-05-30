//
//  DataStoreComponent.swift
//  Lattice
//
//  Created by Zack Brown on 07/03/2026.
//

import Deltille
import RealityKit

public class DataStoreComponent<K: Vertex,
                                V: DataStoreValue>: Component,
                                                    Codable {
    
    public internal(set) var data: [K : V] = [:]
    
    internal var isEmpty: Bool {
        
        data.isEmpty
    }
}
