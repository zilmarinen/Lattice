//
//  HexagonalDataStoreTile.swift
//  Lattice
//
//  Created by Zack Brown on 08/03/2026.
//

import Deltille

public struct HexagonalDataStoreTile<V: Codable>: Codable {
    
    public let triangle: Triangle
    public let vertices: [Triangle.Vertex : V]
}
