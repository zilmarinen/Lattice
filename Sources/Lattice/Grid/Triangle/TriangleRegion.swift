//
//  TriangleRegion.swift
//  Lattice
//
//  Created by Zack Brown on 18/08/2026.
//

import Deltille
import SpriteKit

public class TriangleRegion<C: TriangleChunk>: TriangleNode,
                                               Soilable {
    
    internal enum CodingKeys: CodingKey {
        
        case dirty
    }
    
    private(set) public var isDirty: Bool = false
    
    required public init(_ triangle: Triangle) {
        
        super.init(triangle,
                   .region)
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

public extension TriangleRegion {
    
    func becomeDirty() {
        
        guard !isDirty else { return }
        
        isDirty = true
    }
    
    func clean() {
        
    }
}

internal extension TriangleRegion {
    
    var chunks: [C] {
        
        children.compactMap {
            
            $0 as? C
        }
    }
}

internal extension TriangleRegion {
    
    func chunk(for triangle: Triangle,
               _ from: Triangle.Scale) -> C? {
        
        let chunk = triangle.transpose(from,
                                       .chunk)
        
        return chunks.first {
            
            $0.triangle == chunk
        }
    }
    
    func chunks(intersecting triangle: Triangle,
                _ from: Triangle.Scale) -> [C] {
        
        let chunk = triangle.transpose(from,
                                       .chunk)
        
        return chunks.filter {
            
            $0.triangle == chunk
        }
    }
}

//TODO: REMOVE
public class ExampleTriangleRegion: TriangleRegion<ExampleTriangleChunk> {
    
}
