//
//  Soilable.swift
//  Lattice
//
//  Created by Zack Brown on 28/08/2026.
//

import SpriteKit

internal protocol Soilable: SKNode {
    
    var isDirty: Bool { get set }
    
    func becomeDirty()
    func clean()
}

internal extension Soilable {
    
    func becomeDirty() {
        
        guard !isDirty else { return }
        
        isDirty = true
    }
    
    func clean() {}
}
