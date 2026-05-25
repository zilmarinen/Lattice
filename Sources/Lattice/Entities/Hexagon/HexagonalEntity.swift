//
//  HexagonalEntity.swift
//  Lattice
//
//  Created by Zack Brown on 07/03/2026.
//

import Deltille
import Euclid
import RealityKit

open class HexagonalEntity: Entity,
                            @preconcurrency Codable {
   
   internal enum CodingKeys: CodingKey {
       
       case scale
       case vertex
   }
    
    public let hexagon: Hexagon
    public let scale: Hexagon.Scale
    
    internal init(_ hexagon: Hexagon,
                  _ scale: Hexagon.Scale) {
        
        self.hexagon = hexagon
        self.scale = scale
        
        super.init()
        
        name = hexagon.id
        
        updatePosition()
    }
    
    @available(*, unavailable)
    required public init() { fatalError("init() has not been implemented") }
    
    required public init(from decoder: any Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let vertex = try container.decode(Hexagon.Vertex.self,
                                          forKey: .vertex)
        
        self.hexagon = .init(vertex)
        
        self.scale = try container.decode(Hexagon.Scale.self,
                                          forKey: .scale)
        
        super.init()
        
        name = hexagon.id
        
        updatePosition()
    }
    
    public func encode(to encoder: any Encoder) throws {
    
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(hexagon.vertex,
                             forKey: .vertex)
        
        try container.encode(scale,
                             forKey: .scale)
    }
}

extension HexagonalEntity {
    
    internal func updatePosition() {
        
        switch scale {
            
        case .region:
            
            position = .init(hexagon.position(scale))
            
        case .chunk:
            
            let region = hexagon.transpose(scale,
                                           .region)
            
            position = .init(hexagon.position(scale) - region.position(.region))
        }
    }
}
