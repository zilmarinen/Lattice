//
//  TriangleDataStoreChunk.swift
//  Lattice
//
//  Created by Zack Brown on 03/08/2026.
//

import Deltille

public class TriangleDataStoreChunk<T: DataStoreTile>: DataStoreContainer<Triangle, Triangle.Scale>,
                                                       DataStoreChunk {
    
    internal enum CodingKeys: CodingKey {
        
        case store
    }
    
    public let store: ValueStore<T>
    
    required public init(_ triangle: Triangle) {
        
        self.store = .init()
        
        super.init(triangle,
                   .chunk)
    }
    
    required public init(from decoder: any Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let values = try container.decode([T].self,
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

//TODO: REMOVE
public class ExampleTriangleDataStoreChunk: TriangleDataStoreChunk<ExampleTriangleTile> {
    
}
