//
//  TriangularDataStoreChunk.swift
//  Lattice
//
//  Created by Zack Brown on 07/03/2026.
//

import Deltille
import RealityKit

public class TriangularDataStoreChunk<V: TriangularDataStoreTile>: TriangularDataStoreContainer,
                                                                   DataStoreChunk {

    internal enum CodingKeys: CodingKey {
        
        case store
    }
    
    public let store: DataStoreComponent<V>
    
    required internal init(_ triangle: Triangle) {
        
        self.store = .init()
        
        super.init(triangle,
                   .chunk)
    }
    
    required internal init(from decoder: any Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let values = try container.decode([V].self,
                                          forKey: .store)
        
        self.store = .init(values: values)
        
        try super.init(from: decoder)
    }
    
    override public func encode(to encoder: any Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(Array(store.data.values),
                             forKey: .store)
    }
}
