//
//  DataStoreContainer.swift
//  Lattice
//
//  Created by Zack Brown on 03/08/2026.
//

import Deltille

public class DataStoreContainer<T: Tile,
                                S: Scale>: Codable,
                                           Hashable where T.S == S {
    
    internal enum CodingKeys: CodingKey {
        
        case tile
        case scale
    }
    
    public internal(set) var parent: T?
    
    public let tile: T
    public let scale: S
    
    internal init(_ tile: T,
                  _ scale: S) {
     
        self.tile = tile
        self.scale = scale
    }
    
    required public init(from decoder: any Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.tile = try container.decode(T.self,
                                         forKey: .tile)
        
        self.scale = try container.decode(S.self,
                                          forKey: .scale)
    }
    
    public func encode(to encoder: any Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(tile,
                             forKey: .tile)
                
        try container.encode(scale,
                             forKey: .scale)
    }
}

public extension DataStoreContainer {
    
    static func == (lhs: DataStoreContainer,
                    rhs: DataStoreContainer) -> Bool {
        
        lhs.tile == rhs.tile &&
        lhs.scale == rhs.scale
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(tile)
        hasher.combine(scale)
    }
}
