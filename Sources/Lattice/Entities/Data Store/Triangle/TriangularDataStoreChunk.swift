//
//  TriangularDataStoreChunk.swift
//  Lattice
//
//  Created by Zack Brown on 07/03/2026.
//

import Deltille
import RealityKit

public class TriangularDataStoreChunk<V: TriangularDataStoreTile>: TriangularChunk,
                                                                   HasDataStore {
    
    internal enum CodingKeys: CodingKey {
        
        case store
    }
    
    public let store: DataStoreComponent<Triangle.Vertex, V>
    
    required internal init(_ triangle: Triangle) {
        
        self.store = .init()
        
        super.init(triangle)
        
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

public extension TriangularDataStoreChunk {
    
    func set(_ value: V?,
             for key: K) {
        
        guard let value,
              Triangle(key.position(.tile),
                       .chunk) == triangle else {
            
            remove(values: [key])
            
            return becomeDirty()
        }
        
        store.data[key] = value
        
        becomeDirty()
    }
}
