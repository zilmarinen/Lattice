//
//  Lattice.swift
//  Lattice
//
//  Created by Zack Brown on 18/08/2026.
//

public protocol Lattice: DataStore {
    
    associatedtype G
    associatedtype S: DataStore
    
    var grid: G { get }
    var store: S { get }
}
