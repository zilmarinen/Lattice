//
//  DataStoreContainer.swift
//  Lattice
//
//  Created by Zack Brown on 05/07/2026.
//

import Deltille

open class DataStoreContainer<T: Tile,
                              S: Scale>: Codable,
                                         Hashable where T.S == S,
                                                        T.V: Vertex {
    
    internal enum CodingKeys: CodingKey {
        
        case scale
        case coord
    }
    
    internal var parent: DataStoreContainer?
    internal var children: Set<DataStoreContainer>?
    
    public let tile: T
    public let scale: S
    
    internal init(_ tile: T,
                  _ scale: S) {
        
        self.tile = tile
        self.scale = scale
    }
    
    required public init(from decoder: any Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let coordinate = try container.decode(Coordinate.self,
                                              forKey: .coord)
        
        self.tile = .init(coordinate)
        
        self.scale = try container.decode(S.self,
                                          forKey: .scale)
    }
    
    public func encode(to encoder: any Encoder) throws {
    
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(tile.vertex.position,
                             forKey: .coord)
        
        try container.encode(scale,
                             forKey: .scale)
    }
}

public extension DataStoreContainer {
    
    static func == (lhs: DataStoreContainer,
                    rhs: DataStoreContainer) -> Bool {
        
        lhs.tile == rhs.tile &&
        lhs.scale == rhs.scale
    }

    func hash(into hasher: inout Hasher) {
        
        hasher.combine(tile)
        hasher.combine(scale)
    }
}

internal extension DataStoreContainer {
 
    var hasChildren: Bool {
        
        guard let children else { return false }
        
        return !children.isEmpty
    }
}

internal extension DataStoreContainer {
    
    func add(child: DataStoreContainer) {
        
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

