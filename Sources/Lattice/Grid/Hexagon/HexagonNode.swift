//
//  HexagonNode.swift
//  Lattice
//
//  Created by Zack Brown on 18/08/2026.
//

import Deltille
import SpriteKit

public class HexagonNode: SKNode {
    
    internal enum CodingKeys: CodingKey {
        
        case hexagon
        case scale
    }
    
    public let hexagon: Hexagon
    public let scale: Hexagon.Scale
    
    internal init(_ hexagon: Hexagon,
                  _ scale: Hexagon.Scale) {
     
        self.hexagon = hexagon
        self.scale = scale
        
        super.init()
        
        name = hexagon.id
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    required public init(from decoder: any Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.hexagon = try container.decode(Hexagon.self,
                                            forKey: .hexagon)
        
        self.scale = try container.decode(Hexagon.Scale.self,
                                          forKey: .scale)
        
        super.init()
        
        name = hexagon.id
    }
    
    public func encode(to encoder: any Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(hexagon,
                             forKey: .hexagon)
                
        try container.encode(scale,
                             forKey: .scale)
    }
}
