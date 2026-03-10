//
//  HasFootprint.swift
//  Lattice
//
//  Created by Zack Brown on 10/03/2026.
//

import Deltille

public protocol HasFootprint: Codable,
                              Hashable {
    
    var origin: Triangle { get }
    
    var footprint: Triangle.Footprint { get }
    
    var rotation: Triangle.Rotation? { get }
}
