//
//  DataStoreChunk.swift
//  Lattice
//
//  Created by Zack Brown on 22/08/2026.
//

import Deltille
import SpriteKit

public class DataStoreChunk<T: Tile,
                            V: DataStoreValue>: DataStoreNode<T> {
    
    internal enum CodingKeys: CodingKey {
           
        case data
    }
    
    internal var data: [V.K : V]
    
    required internal init(_ tile: T,
                           _ lattice: Double = 1.0) {
        
        data = [:]
        
        super.init(tile,
                   .chunk,
                   lattice)
    }
    
    @available(*, unavailable)
    required internal init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    required internal init(from decoder: any Decoder) throws {
         
        let container = try decoder.container(keyedBy: CodingKeys.self)
                
        data = try container.decode([V.K : V].self,
                                    forKey: .data)
        
        try super.init(from: decoder)
    }
    
    override internal func encode(to encoder: any Encoder) throws {
            
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(data,
                             forKey: .data)
    }
}

internal extension DataStoreChunk {
    
    var isEmpty: Bool {
        
        data.isEmpty
    }
}

internal extension DataStoreChunk {
    
    func merge(_ other: [V.K : V]) {
        
        data.merge(other) { (current, _) in current }
    }
    
    func remove(_ keys: Set<V.K>) {
        
        keys.forEach {
            
            data.removeValue(forKey: $0)
        }
    }
    
    func set(_ value: V,
             for key: V.K) {
        
        data[key] = value
    }
    
    func value(for key: V.K) -> V? {
        
        data[key]
    }
}
