//
//  DataStoreNode.swift
//  Lattice
//
//  Created by Zack Brown on 22/08/2026.
//

import Deltille
import SpriteKit

public class DataStoreNode<T: Tile>: SKShapeNode {
    
    internal enum CodingKeys: CodingKey {
        
        case lattice
        case tile
        case scale
    }
    
    public let tile: T
    public let scale: Scale
    public let lattice: Double
    
    internal init(_ tile: T,
                  _ scale: Scale,
                  _ lattice: Double) {
     
        self.tile = tile
        self.scale = scale
        self.lattice = lattice
        
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
        
        self.lattice = try container.decode(Double.self,
                                            forKey: .lattice)
        
        super.init()
        
        update()
    }
    
    internal func encode(to encoder: any Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(tile,
                             forKey: .tile)
                
        try container.encode(scale,
                             forKey: .scale)
        
        try container.encode(lattice,
                             forKey: .lattice)
    }
}

private extension DataStoreNode {
    
    func update() {
        
        name = tile.id
        path = CGPath.tile(tile,
                           scale,
                           lattice)
        lineWidth = 2.0
        strokeColor = scale == .chunk ? .black : .white
        
        switch scale {
            
        case .chunk:
            
            let region = tile.transpose(scale,
                                        .region)
            
            let origin = region.transpose(.region,
                                          .tile)
            
            let offset = tile.transpose(scale,
                                        .tile)
            
            position = .init((offset - origin).vertex,
                             lattice)
            
        default:
            
            let origin = tile.transpose(scale,
                                        .tile)
            
            position = .init(origin.vertex,
                             lattice)
        }
    }
}
