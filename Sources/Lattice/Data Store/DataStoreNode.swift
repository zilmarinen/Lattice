//
//  DataStoreNode.swift
//  Lattice
//
//  Created by Zack Brown on 22/08/2026.
//

import Deltille
import SpriteKit

internal class DataStoreNode<T: Tile>: SKShapeNode {
    
    internal enum CodingKeys: CodingKey {
        
        case tile
        case scale
    }
    
    public let tile: T
    public let scale: Scale
    
    internal init(_ tile: T,
                  _ scale: Scale) {
     
        self.tile = tile
        self.scale = scale
        
        super.init()
        
        update()
    }
    
    @available(*, unavailable)
    required internal init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    required internal init(from decoder: any Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.tile = try container.decode(T.self,
                                         forKey: .tile)
        
        self.scale = try container.decode(Scale.self,
                                          forKey: .scale)
        
        super.init()
        
        update()
    }
    
    internal func encode(to encoder: any Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(tile,
                             forKey: .tile)
                
        try container.encode(scale,
                             forKey: .scale)
    }
}

private extension DataStoreNode {
    
    func update() {
        
        name = tile.id
        path = CGPath.tile(tile,
                           scale)
        lineWidth = 2.0
        strokeColor = .black
        
        switch scale {
            
        case .chunk:
            
            let region = tile.transpose(scale,
                                        .region)
            
            position = .init(tile.vertex - region.vertex)
            
        default:
            
            position = .init(tile.vertex)
        }
    }
}
