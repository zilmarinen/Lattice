//
//  DataStoreNode.swift
//  Lattice
//
//  Created by Zack Brown on 22/08/2026.
//

import Deltille
import SpriteKit

internal class DataStoreNode<T: Tile,
                             S: Scale>: SKShapeNode where T.S == S {
    
    internal enum CodingKeys: CodingKey {
        
        case tile
        case scale
    }
    
    public let tile: T
    public let scale: S
    
    public init(_ tile: T,
                _ scale: S) {
     
        self.tile = tile
        self.scale = scale
        
        super.init()
        
        name = tile.id
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    required public init(from decoder: any Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.tile = try container.decode(T.self,
                                         forKey: .tile)
        
        self.scale = try container.decode(S.self,
                                          forKey: .scale)
        
        super.init()
        
        name = tile.id
    }
    
    public func encode(to encoder: any Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(tile,
                             forKey: .tile)
                
        try container.encode(scale,
                             forKey: .scale)
    }
}
