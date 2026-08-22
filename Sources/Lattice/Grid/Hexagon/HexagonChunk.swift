//
//  HexagonRegion.swift
//  Lattice
//
//  Created by Zack Brown on 18/08/2026.
//

import Deltille
import SpriteKit

public class HexagonChunk: HexagonNode,
                           Soilable {
    
    internal enum CodingKeys: CodingKey {
        
        case dirty
    }
    
    private(set) public var isDirty: Bool = false
    
    required public init(_ hexagon: Hexagon) {
        
        super.init(hexagon,
                   .chunk)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    required public init(from decoder: any Decoder) throws {
     
        let container = try decoder.container(keyedBy: CodingKeys.self)
                
        isDirty = try container.decode(Bool.self,
                                       forKey: .dirty)
        
        try super.init(from: decoder)
    }
    
    override public func encode(to encoder: any Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(isDirty,
                             forKey: .dirty)
    }
}

public extension HexagonChunk {
    
    func becomeDirty() {
        
        guard !isDirty else { return }
        
        isDirty = true
        
        guard let parent = parent as? Soilable else { return }
        
        parent.becomeDirty()
    }
    
    func clean() {
        
    }
}

//TODO: REMOVE
public class ExampleHexagonChunk: HexagonChunk {
    
}
