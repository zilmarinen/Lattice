//
//  DataStore.swift
//  Lattice
//
//  Created by Zack Brown on 03/08/2026.
//

import Deltille

public protocol DataStore {
    
    associatedtype V: DataStoreValue
    //associatedtype S: Sieve
    
    func remove(_ keys: [V.V])
    
    func set(_ value: V)
    
    func value(for key: V.V) -> V?
    
    //func wedge(for sieve: S) -> DataStoreWedge<V>
}

//public extension DataStore {
//    
//    func wedge(for sieve: S) -> DataStoreWedge<V> {
//        
//        let wedge = sieve.tiles.reduce(into: [V.V : V]()) { result, tile in
//        
//            result[tile] = value(for: tile)
//        }
//        
//        return .init(values: wedge)
//    }
//}
