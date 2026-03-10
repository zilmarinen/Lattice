//
//  SoilableComponent.swift
//  Lattice
//
//  Created by Zack Brown on 07/03/2026.
//

import RealityKit

public struct SoilableComponent: Component {
    
    internal var isDirty: Bool = false
}

public protocol HasSoilableComponent: Entity {
    
    var soilableComponent: SoilableComponent { get set }
    
    func becomeDirty()
}

public extension HasSoilableComponent {
    
    var soilableComponent: SoilableComponent {
        
        get {
            
            let component = components[SoilableComponent.self] ?? .init()
            
            if components[SoilableComponent.self] == nil {
                
                components.set(component)
            }
            
            return component
        }
        
        set {
            
            components.set(newValue)
        }
    }
    
    var isDirty: Bool {
        
        get {
            
            soilableComponent.isDirty
        }
        
        set {
            
            soilableComponent.isDirty = newValue
        }
    }
    
    func becomeDirty() {
        
        guard !isDirty else { return }
        
        soilableComponent.isDirty = true
    }
}
