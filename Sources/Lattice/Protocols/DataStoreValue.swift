//
//  DataStoreValue.swift
//  Lattice
//
//  Created by Zack Brown on 08/03/2026.
//

import Deltille

public protocol DataStoreValue: Codable,
                                Hashable {
    
    var vertex: Triangle.Vertex { get }
}
