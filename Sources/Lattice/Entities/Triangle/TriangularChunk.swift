//
//  TriangularChunk.swift
//  Lattice
//
//  Created by Zack Brown on 07/03/2026.
//

import Deltille
import RealityKit

open class TriangularChunk: TriangularEntity,
                            HasSoilableComponent {
    
    internal enum CodingKeys: CodingKey {
        
        case dirty
    }
    
    required public init(_ triangle: Triangle) {
        
        super.init(triangle,
                   .chunk)
    }
    
    @available(*, unavailable)
    required public init() { fatalError("init() has not been implemented") }
    
    required public init(from decoder: any Decoder) throws {
        
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        isDirty = try container.decode(Bool.self,
                                       forKey: .dirty)
    }
    
    override open func encode(to encoder: any Encoder) throws {
    
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(isDirty,
                             forKey: .dirty)
    }
}
