//
//  DataStore.swift
//  Lattice
//
//  Created by Zack Brown on 03/08/2026.
//

import Deltille

public protocol DataStore where T.T.SI.T == T.V {
    
    associatedtype T: DataStoreTile
    
    func remove(_ keys: [T.V])
    
    func set(_ value: T)
    
    func value(for key: T.V) -> T?
    
    func wedge(for sieve: T.T.SI) -> DataStoreWedge<T>
}

public extension DataStore {
    
    func wedge(for sieve: T.T.SI) -> DataStoreWedge<T> {
        
        let wedge = sieve.tiles.reduce(into: [T.V : T]()) { result, tile in
        
            result[tile] = value(for: tile)
        }
        
        return .init(values: wedge)
    }
}
