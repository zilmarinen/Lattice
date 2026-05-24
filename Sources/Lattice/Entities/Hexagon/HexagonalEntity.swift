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
            
            //REMOVE
            guard region.transpose(.region,
                                   .chunk) != hexagon else { return }
        }
        
        let vertices = hexagon.vertices.position(scale)
        let color: Color = scale == .region ? .red : .blue
        let elevation: Float = scale == .region ? 0.01 : 0.02
        
        guard let surface = Polygon.surface(vertices,
                                            color),
              let entity = try? ModelEntity(Mesh([surface])) else { return }

        entity.position = -.init(hexagon.position(.chunk)) - [0.0, elevation, 0.0]
        entity.model?.materials = [SimpleMaterial(color: .init(color),
                                                  isMetallic: false)]

        addChild(entity)
    }
}

public extension Polygon {
    
    static func surface(_ vectors: [Vector],
                        _ color: Color) -> Self? {
        
        guard vectors.count >= 3 else { return nil }
        
        let a = vectors[0]
        let b = vectors[1]
        let c = vectors[2]
        
        let ac = c - a
        let bc = c - b
        
        let normal = ac.cross(bc).normalized()
        
        let vertices = vectors.map {
            
            Vertex($0,
                   normal,
                   nil,
                   color)
        }
        
        return Polygon(vertices)
    }
}
