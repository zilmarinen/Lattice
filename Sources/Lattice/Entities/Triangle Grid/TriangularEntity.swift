//
//  TriangularEntity.swift
//  Lattice
//
//  Created by Zack Brown on 07/03/2026.
//

import Deltille
import RealityKit

open class TriangularEntity: Entity,
                             @preconcurrency Codable {
    
    internal enum CodingKeys: CodingKey {
        
        case scale
        case vertex
    }
    
    public let tile: Triangle
    public let scale: Triangle.Scale
    
    internal init(_ tile: Triangle,
                  _ scale: Triangle.Scale) {
        
        self.tile = tile
        self.scale = scale
        
        super.init()
        
        name = tile.id
        
        updatePosition()
    }
    
    @available(*, unavailable)
    required public init() { fatalError("init() has not been implemented") }
    
    required public init(from decoder: any Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let coordinate = try container.decode(Coordinate.self,
                                              forKey: .vertex)
        
        self.tile = .init(coordinate)
        
        self.scale = try container.decode(Triangle.Scale.self,
                                          forKey: .scale)
        
        super.init()
        
        name = tile.id
        
        updatePosition()
    }
    
    open func encode(to encoder: any Encoder) throws {
    
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(tile.vertex.position,
                             forKey: .vertex)
        
        try container.encode(scale,
                             forKey: .scale)
    }
}

extension TriangularEntity {
    
    internal func updatePosition() {
        
        switch scale {
            
        case .region:
            
            position = .init(tile.position(scale))
            
        case .chunk:
            
            let region = tile.transpose(scale,
                                        .region)
            
            position = .init(tile.position(scale) - region.position(.region))
            
        default:
            
            position = .zero
        }
    }
}
