//
//  HexagonalGridDataStoreTile.swift
//  Lattice
//
//  Created by Zack Brown on 08/03/2026.
//

import Deltille

internal struct HexagonalGridDataStoreTile<V: Codable>: Codable {
    
    internal let tile: Triangle
    internal let vertices: [Triangle.Vertex : V]
}
