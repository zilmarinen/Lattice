//
//  HexagonalDataStoreContainer.swift
//  Lattice
//
//  Created by Zack Brown on 28/06/2026.
//

import Deltille

open class HexagonalDataStoreContainer: Codable,
                                        Hashable {
    
    internal enum CodingKeys: CodingKey {
        
        case children
        case scale
        case vertex
    }
    
    internal var parent: HexagonalDataStoreContainer?
    internal var children: [HexagonalDataStoreContainer] = []
    
    public let hexagon: Hexagon
    public let scale: Hexagon.Scale
    
    internal init(_ hexagon: Hexagon,
                  _ scale: Hexagon.Scale) {
        
        self.hexagon = hexagon
        self.scale = scale
    }
    
    required public init(from decoder: any Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let coordinate = try container.decode(Coordinate.self,
                                              forKey: .vertex)
        
        self.hexagon = .init(coordinate)
        
        self.scale = try container.decode(Hexagon.Scale.self,
                                          forKey: .scale)
        
        self.children = try container.decode([HexagonalDataStoreContainer].self,
                                             forKey: .children)
        
        self.children.forEach {
            
            $0.parent = self
        }
    }
    
    public func encode(to encoder: any Encoder) throws {
    
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(hexagon.vertex.position,
                             forKey: .vertex)
        
        try container.encode(scale,
                             forKey: .scale)
        
        try container.encode(children,
                             forKey: .children)
    }
}

public extension HexagonalDataStoreContainer {
    
    static func == (lhs: HexagonalDataStoreContainer,
                    rhs: HexagonalDataStoreContainer) -> Bool {
        
        lhs.hexagon == rhs.hexagon &&
        lhs.scale == rhs.scale
    }

    func hash(into hasher: inout Hasher) {
        
        hasher.combine(hexagon)
        hasher.combine(scale)
    }
}

internal extension HexagonalDataStoreContainer {
    
    func add(child: HexagonalDataStoreContainer) {
        
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
