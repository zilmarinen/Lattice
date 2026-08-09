//
//  DataStoreChunk.swift
//  Lattice
//
//  Created by Zack Brown on 03/08/2026.
//

import Deltille

public class DataStoreChunk<T: Tile,
                            S: Scale,
                            V: DataStoreValue>: DataStoreContainer<T, S> where T.S == S {

    internal enum CodingKeys: CodingKey {

        case store
    }

    public let store: ValueStore<V>
    
    override public init(_ tile: T,
                         _ scale: S) {

        self.store = .init()

        super.init(tile,
                   scale)
    }

    required public init(from decoder: any Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        let values = try container.decode([V].self,
                                          forKey: .store)

        self.store = .init(values: values)

        try super.init(from: decoder)
    }

    override public func encode(to encoder: any Encoder) throws {

        try super.encode(to: encoder)

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(Array(store.data.values),
                             forKey: .store)
    }
}

public extension DataStoreChunk {

    var isEmpty: Bool {

        store.isEmpty
    }
}

public extension DataStoreChunk {

    func merge(_ other: DataStoreChunk) {

        store.data.merge(other.store.data) { (current, _) in

            current
        }
    }

    func set(_ value: V) {
        print("Setting: \(value.vertex.id)")
        store.data[value.vertex] = value
    }

    func remove(_ keys: [V.V]) {

        keys.forEach {

            store.data.removeValue(forKey: $0)
        }
    }

    func value(for key: V.V) -> V? {

        store.data[key]
    }
}
