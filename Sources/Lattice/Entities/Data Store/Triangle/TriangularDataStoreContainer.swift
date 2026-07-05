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
        
        case scale
        case vertex
    }
    
    internal var parent: TriangularDataStoreContainer?
    internal var children: Set<TriangularDataStoreContainer>?
    
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
    }
    
    public func encode(to encoder: any Encoder) throws {
    
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(triangle.vertex.position,
                             forKey: .vertex)
        
        try container.encode(scale,
                             forKey: .scale)
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
 
    var hasChildren: Bool {
        
        guard let children else { return false }
        
        return !children.isEmpty
    }
}

internal extension TriangularDataStoreContainer {
    
    func add(child: TriangularDataStoreContainer) {
        
        child.removeFromParent()
        
        if children == nil {
            
            children = []
        }
        
        children?.insert(child)
        
        child.parent = self
    }
    
    func removeFromParent() {
        
        guard let parent else { return }
        
        if let index = parent.children?.firstIndex(of: self) {
            
            parent.children?.remove(at: index)
        }
        
        self.parent = nil
    }
}
