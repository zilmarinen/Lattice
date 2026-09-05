//
//  Grid.swift
//  Lattice
//
//  Created by Zack Brown on 31/08/2026.
//

import Deltille
import SpriteKit

public class Grid<R: GridRegion<C, T>,
                  C: GridChunk<T>,
                  T: Tile>: SKNode {
    
    public let lattice: Double
    
    required public init(_ lattice: Double) {
        
        self.lattice = lattice
        
        super.init()
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

internal extension Grid {
    
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

internal extension Grid {
    
    func region(for tile: T,
                _ from: Scale) -> R? {
        
        let region = tile.transpose(from,
                                    .region)
        
        return regions.first {
            
            $0.tile == region
        }
    }
    
    func chunk(for tile: T,
               _ from: Scale) -> C? {
        
        guard let region = region(for: tile,
                                  from) else { return nil }
        
        return region.chunk(for: tile,
                            from)
    }
}

internal extension Grid {
    
    func propagate(_ keys: Set<T>,
                   _ insertion: Bool = false) {
        
        let partitions = keys.reduce(into: [T : Set<T>]()) { result, vertex in
        
            let region = vertex.transpose(.chunk,
                                          .region)
            
            var partition = result[region] ?? []
            
            partition.insert(vertex)
            
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
                
                let region = region ?? R(partition,
                                         lattice)
                
                let chunk = region.chunk(for: triangle,
                                         .chunk) ?? C(triangle,
                                                      lattice)
                
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
