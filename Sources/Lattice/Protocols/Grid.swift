//
//  Grid.swift
//  Lattice
//
//  Created by Zack Brown on 07/09/2026.
//

import Deltille
import SpriteKit

public protocol Grid: SKNode {
    
    associatedtype C: TileChunk<T>
    associatedtype R: TileRegion<C, T>
    associatedtype T: Tile
    
    var lattice: Double { get }
    
    var regions: [R] { get }
    
    var dirtyRegions: [R] { get }
    
    func region(for tile: T,
                _ from: Scale) -> R?
    
    func chunk(for tile: T,
               _ from: Scale) -> C?
    
    func propagate(_ keys: Set<T>,
                   _ insertion: Bool)
}

public extension Grid {
    
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

public extension Grid {
    
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

public extension Grid {
    
    func propagate(_ keys: Set<T>,
                   _ insertion: Bool = false) {
        
        let partitions = keys.reduce(into: [T : Set<T>]()) { result, tile in
        
            let region = tile.transpose(.chunk,
                                        .region)
            
            var partition = result[region] ?? []
            
            partition.insert(tile)
            
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
