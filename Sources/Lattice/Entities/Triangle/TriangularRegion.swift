//
//  TriangularRegion.swift
//  Lattice
//
//  Created by Zack Brown on 07/03/2026.
//

import Deltille
import RealityKit

public class TriangularRegion<C: TriangularChunk>: TriangularEntity,
                                                   DefinesHierarchy,
                                                   HasSoilableComponent {
    
    internal enum CodingKeys: CodingKey {
        
        case chunks
        case dirty
    }
    
    required public init(_ triangle: Triangle) {
        
        super.init(triangle,
                   .region)
    }
    
    @available(*, unavailable)
    required internal init() { fatalError("init() has not been implemented") }
    
    required internal init(from decoder: any Decoder) throws {
        
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        isDirty = try container.decode(Bool.self,
                                       forKey: .dirty)
        
        let children = try container.decode([C].self,
                                            forKey: .chunks)
        
        children.forEach {
            
            addChild($0)
        }
    }
    
    override public func encode(to encoder: any Encoder) throws {
    
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(chunks,
                             forKey: .chunks)

        try container.encode(isDirty,
                             forKey: .dirty)
    }
}

public extension TriangularRegion {
    
    var descendants: [C] {
        
        chunks
    }
    
    var chunks: [C] {
        
        children.compactMap {
            
            $0 as? C
        }
    }
    
    var dirtyChunks: [C] {
        
        chunks.filter {
            
            $0.isDirty
        }
    }
}

extension TriangularRegion {
    
    internal func chunk(for triangle: Triangle,
                        _ from: Triangle.Scale) -> C? {
        
        let chunk = triangle.transpose(from,
                                       .chunk)
        
        return chunks.first {
            
            $0.triangle == chunk
        }
    }
    
    internal func chunks(intersecting triangle: Triangle,
                         _ from: Triangle.Scale) -> [C] {
        
        let chunk = triangle.transpose(from,
                                       .chunk)
        
        return chunks.filter {
            
            $0.triangle == chunk
        }
    }
}
