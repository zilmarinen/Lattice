//
//  PropagatesChanges.swift
//  Lattice
//
//  Created by Zack Brown on 10/05/2026.
//

import Deltille
import RealityKit

public protocol PropagatesChanges: Entity {
    
    func propagate(triangle: Triangle,
                   _ createHierarchy: Bool)
    func propagate(vertex: Triangle.Vertex,
                   _ createHierarchy: Bool)
}
