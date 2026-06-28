//
//  TriangularDataStoreContainer.swift
//  Lattice
//
//  Created by Zack Brown on 28/06/2026.
//

import Deltille

open class TriangularDataStoreContainer: Codable,
                                         Hashable {
    
    internal enum CodingKeys: CodingKey {
        
        case children
        case scale
        case vertex
    }
    
    internal var parent: TriangularDataStoreContainer?
    internal var children: [TriangularDataStoreContainer] = []
    
    public let triangle: Triangle
    public let scale: Triangle.Scale
    
    internal init(_ triangle: Triangle,
                  _ scale: Triangle.Scale) {
        
        self.triangle = triangle
        self.scale = scale
    }
    
    required public init(from decoder: any Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let coordinate = try container.decode(Coordinate.self,
                                              forKey: .vertex)
        
        self.triangle = .init(coordinate)
        
        self.scale = try container.decode(Triangle.Scale.self,
                                          forKey: .scale)
        
        self.children = try container.decode([TriangularDataStoreContainer].self,
                                             forKey: .children)
        
        self.children.forEach {
            
            $0.parent = self
        }
    }
    
    public func encode(to encoder: any Encoder) throws {
    
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(triangle.vertex.position,
                             forKey: .vertex)
        
        try container.encode(scale,
                             forKey: .scale)
        
        try container.encode(children,
                             forKey: .children)
    }
}

public extension TriangularDataStoreContainer {
    
    static func == (lhs: TriangularDataStoreContainer,
                    rhs: TriangularDataStoreContainer) -> Bool {
        
        lhs.triangle == rhs.triangle &&
        lhs.scale == rhs.scale
    }

    func hash(into hasher: inout Hasher) {
        
        hasher.combine(triangle)
        hasher.combine(scale)
    }
}

internal extension TriangularDataStoreContainer {
    
    func add(child: TriangularDataStoreContainer) {
        
        child.removeFromParent()
        
        children.append(child)
        
        child.parent = self
    }
    
    func removeFromParent() {
        
        guard let parent else { return }
        
        if let index = parent.children.firstIndex(of: self) {
            
            parent.children.remove(at: index)
        }
        
        self.parent = nil
    }
}
