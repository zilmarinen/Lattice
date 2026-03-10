//
//  HexagonalChunkDataStore.swift
//  Lattice
//
//  Created by Zack Brown on 08/03/2026.
//

import Deltille
import RealityKit

public class HexagonalChunkDataStore<V: Codable>: HexagonalEntity,
                                                  HasDataStore {
    
    internal enum CodingKeys: CodingKey {
        
        case store
    }
    
    internal let store: DataStoreComponent<Triangle.Vertex, V>
    
    required public init(_ hexagon: Hexagon) {
        
        self.store = .init()
        
        super.init(hexagon,
                   .chunk)
        
        components.set(store)
    }
    
    @available(*, unavailable)
    required internal init() { fatalError("init() has not been implemented") }
    
    required internal init(from decoder: any Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.store = try container.decode(DataStoreComponent<Triangle.Vertex, V>.self,
                                          forKey: .store)
        
        try super.init(from: decoder)
        
        components.set(store)
    }
    
    override public func encode(to encoder: any Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(store,
                             forKey: .store)
    }
}

internal extension HexagonalChunkDataStore {
    
    func set(_ value: V?,
             for key: K) {
        
        guard let value,
              Hexagon(key.position(.tile),
                      .chunk) == hexagon else {
            
            remove(values: [key])
            
            return
        }
        
        store.data[key] = value
    }
}
