//
//  HexagonalGrid.swift
//  Lattice
//
//  Created by Zack Brown on 28/08/2026.
//

import Deltille
import SpriteKit

public class HexagonalGrid<R: HexagonalRegion<C>,
                           C: HexagonalChunk>: SKNode {}

internal extension HexagonalGrid {
    
    var regions: [R] {
        
        children.compactMap {
            
            $0 as? R
        }
    }
    
    var dirtyRegions: [R] {
        
        regions.filter {
            
            $0.isDirty
        }
    }
}

internal extension HexagonalGrid {
    
    func region(for hexagon: Hexagon,
                _ from: Scale) -> R? {
        
        let region = hexagon.transpose(from,
                                       .region)
        
        return regions.first {
            
            $0.tile == region
        }
    }
}

internal extension HexagonalGrid {
 
    func propagate(_ keys: Set<Hexagon>,
                   _ insertion: Bool = false) {
        
        let partitions = keys.reduce(into: [Hexagon : Set<Hexagon>]()) { result, vertex in
        
            let chunk = vertex.transpose(.tile,
                                         .chunk)
            
            let region = chunk.transpose(.chunk,
                                         .region)
            
            var partition = result[region] ?? []
            
            partition.insert(chunk)
            
            result[region] = partition
        }
        
        for (partition, chunks) in partitions {
            
            let region = region(for: partition,
                                .region)
            
            for triangle in chunks {
                
                guard insertion else {
                    
                    guard let chunk = region?.chunk(for: triangle,
                                                    .chunk) else { return }
                    
                    chunk.becomeDirty()
                    
                    region?.becomeDirty()
                    
                    return
                }
                
                let region = region ?? R(tile: partition)
                
                let chunk = region.chunk(for: triangle,
                                         .chunk) ?? C(tile: triangle)
                
                if region.parent == nil {
                    
                    addChild(region)
                }
                
                if chunk.parent == nil {
                    
                    region.addChild(chunk)
                }
                
                chunk.becomeDirty()
                
                region.becomeDirty()
            }
        }
    }
}
