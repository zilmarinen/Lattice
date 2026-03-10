//
//  HexagonalLatticeSlice.swift
//  Lattice
//
//  Created by Zack Brown on 10/03/2026.
//

import Deltille

@MainActor
public struct HexagonalLatticeSlice<C: TriangularChunk,
                                    V: Codable>: Codable,
                                                 @preconcurrency Equatable,
                                                 @preconcurrency Hashable  {
    
    public let dataSource: [HexagonalChunkDataStore<V>]
    public let region: TriangularRegion<C>
    
    public init(dataSource: [HexagonalChunkDataStore<V>],
                region: TriangularRegion<C>) {
        
        self.dataSource = dataSource
        self.region = region
    }
    
    public func hash(into hasher: inout Hasher) {
        
        hasher.combine(region.triangle)
    }
    
    public static func == (lhs: HexagonalLatticeSlice,
                           rhs: HexagonalLatticeSlice) -> Bool {
        
        lhs.region.triangle == rhs.region.triangle
    }
}

public extension HexagonalLatticeSlice {
    
    var isEmpty: Bool {
        
        dataSource.isEmpty
    }
 
    func remove(values keys: [Triangle.Vertex]) {
        
        dataSource.forEach {
            
            $0.remove(values: keys)
        }
        
        region.chunks.forEach {
            
            $0.becomeDirty()
        }
        
        region.becomeDirty()
    }
}
