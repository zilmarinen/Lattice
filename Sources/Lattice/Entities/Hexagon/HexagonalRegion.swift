//
//  HexagonalRegion.swift
//  Lattice
//
//  Created by Zack Brown on 07/03/2026.
//

import Deltille
import RealityKit

public class HexagonalRegion<C: HexagonalChunk>: HexagonalEntity,
                                                 DefinesHierarchy {
    
    internal enum CodingKeys: CodingKey {
        
        case chunks
    }
    
    required internal init(_ hexagon: Hexagon) {
        
        super.init(hexagon,
                   .region)
    }
    
    @available(*, unavailable)
    required internal init() { fatalError("init() has not been implemented") }
    
    required internal init(from decoder: any Decoder) throws {
        
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
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
    }
}

public extension HexagonalRegion {
    
    var descendants: [C] {
        
        chunks
    }
    
    var chunks: [C] {
        
        children.compactMap {
            
            $0 as? C
        }
    }
}

public extension HexagonalRegion {
    
    func chunk(for hexagon: Hexagon,
               _ from: Hexagon.Scale) -> C? {
        
        let chunk = hexagon.transpose(from,
                                      .chunk)
        
        return chunks.first {
            
            $0.hexagon == chunk
        }
    }
    
    func chunks(intersecting triangle: Triangle,
                _ from: Triangle.Scale) -> [C] {
        
        chunks.filter {
            
            for vertex in $0.hexagon.vertices {
                
                let match = Triangle(vertex.position(.chunk),
                                     from)
                
                if match == triangle {
                    
                    return true
                }
            }
            
            for vertex in triangle.vertices {
                
                let match = Hexagon(vertex.position(from),
                                    .chunk)
                
                if match == $0.hexagon {
                    
                    return true
                }
            }
            
            return false
        }
    }
}
