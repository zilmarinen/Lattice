//
//  DefinesHierarchy.swift
//  Lattice
//
//  Created by Zack Brown on 10/04/2026.
//

@MainActor
public protocol DefinesHierarchy: Equatable,
                                  Hashable {
    
    associatedtype D
    
    var descendants: [D] { get }
    var numberOfDescendants: Int { get }
    
    func descendant(at index: Int) -> D
}

public extension DefinesHierarchy {
    
    var numberOfDescendants: Int {
        
        descendants.count
    }
    
    func descendant(at index: Int) -> D {
        
        descendants[index]
    }
}
