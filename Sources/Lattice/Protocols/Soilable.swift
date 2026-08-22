//
//  Soilable.swift
//  Lattice
//
//  Created by Zack Brown on 18/08/2026.
//

@MainActor
public protocol Soilable: Sendable {
    
    var isDirty: Bool { get }
    
    func becomeDirty()
    func clean()
}
