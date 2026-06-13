//
//  HexagonalDataStoreChunk.swift
//  Lattice
//
//  Created by Zack Brown on 08/03/2026.
//

import Deltille
import RealityKit

public class HexagonalDataStoreChunk<V: DataStoreValue>: HexagonalChunk,
                                                         DataStoreChunk {
    
    internal enum CodingKeys: CodingKey {
        
        case store
    }
    
    public let store: DataStoreComponent<V>
    
    required internal init(_ hexagon: Hexagon) {
        
        self.store = .init()
        
        super.init(hexagon)
        
        components.set(store)
    }
    
    @available(*, unavailable)
    required internal init() { fatalError("init() has not been implemented") }
    
    required internal init(from decoder: any Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let values = try container.decode([V].self,
                                          forKey: .store)
        
        self.store = .init(values: values)
        
        try super.init(from: decoder)
        
        components.set(store)
    }
    
    override public func encode(to encoder: any Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(Array(store.data.values),
                             forKey: .store)
    }
}
