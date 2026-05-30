//
//  PropagatesChanges.swift
//  Lattice
//
//  Created by Zack Brown on 10/05/2026.
//

import Deltille
import RealityKit

public protocol PropagatesChanges: Entity {
    
    associatedtype K
    
    func propagate(_ keys: [K],
                   _ createHierarchy: Bool)
}
