//
//  TriangularDataStoreTile.swift
//  Lattice
//
//  Created by Zack Brown on 10/03/2026.
//

import Deltille

public protocol TriangularDataStoreTile: Codable,
                                         DataStoreValue,
                                         Hashable {
    
    var footprint: [Coordinate] { get }
    
    var rotation: Triangle.Rotation { get }
}

public extension TriangularDataStoreTile {
    
    var triangle: Triangle {
        
        .init(vertex)
    }
}

internal extension TriangularDataStoreTile {
    
    var tiles: [Triangle] {
        
        ([coord] + footprint).map {
            
            Triangle($0)
        }
    }
    
    func unique(_ from: Triangle.Scale,
                _ to: Triangle.Scale) -> [Triangle] {
        
        tiles.unique(from,
                     to)
    }
}
