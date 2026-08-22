//
//  TriangleNode.swift
//  Lattice
//
//  Created by Zack Brown on 18/08/2026.
//

import Deltille
import SpriteKit

public class TriangleNode: SKNode {
    
    internal enum CodingKeys: CodingKey {
        
        case triangle
        case scale
    }
    
    public let triangle: Triangle
    public let scale: Triangle.Scale
    
    public init(_ triangle: Triangle,
                _ scale: Triangle.Scale) {
     
        self.triangle = triangle
        self.scale = scale
        
        super.init()
        
        name = triangle.id
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    required public init(from decoder: any Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.triangle = try container.decode(Triangle.self,
                                             forKey: .triangle)
        
        self.scale = try container.decode(Triangle.Scale.self,
                                          forKey: .scale)
        
        super.init()
        
        name = triangle.id
    }
    
    public func encode(to encoder: any Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(triangle,
                             forKey: .triangle)
                
        try container.encode(scale,
                             forKey: .scale)
    }
}
