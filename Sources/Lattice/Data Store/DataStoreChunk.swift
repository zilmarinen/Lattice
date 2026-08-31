//
//  DataStoreChunk.swift
//  Lattice
//
//  Created by Zack Brown on 22/08/2026.
//

import Deltille
import SpriteKit

internal class DataStoreChunk<T: Tile,
                              V: DataStoreValue>: DataStoreNode<T> {
    
    internal enum CodingKeys: CodingKey {
           
        case data
    }
    
    internal var data: [V.C : V]
    
    override required internal init(_ tile: T,
                                    _ scale: Scale) {
        
        data = [:]
        
        super.init(tile,
                   scale)
    }
    
    @available(*, unavailable)
    required internal init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    required internal init(from decoder: any Decoder) throws {
         
        let container = try decoder.container(keyedBy: CodingKeys.self)
                
        data = try container.decode([V.C : V].self,
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
    
    func merge(_ other: [V.C : V]) {
        
        data.merge(other) { (current, _) in current }
    }
    
    func remove(_ keys: Set<V.C>) {
        
        keys.forEach {
            
            data.removeValue(forKey: $0)
        }
    }
    
    func set(_ value: V,
             for key: V.C) {
        
        data[key] = value
    }
    
    func value(for key: V.C) -> V? {
        
        data[key]
    }
}
