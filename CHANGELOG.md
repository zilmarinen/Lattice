# CHANGELOG

## [0.2.0](https://github.com/zilmarinen/Lattice/releases/tag/0.2.0) (11/11/2026)

- Refactor Data Store types

    - Refactor existing protocols into `DataStoreNode` subclasses  
    - Add typed data stores for `Tile` and `Vertex` 
    
- Refactor Grid Hierarchy

    - Refactor and combine Grid, Region and Chunk nodes into generic `Tile` based implementation
    
- Refactor Lattice types

    - Remove typed lattices for specific `Tile` types
    - Introduce `Tile` and `Vertex` lattice variants with generic implementations
    
- Introduce variable lattice sizing 
    
- Remove reliance on RealityKit

- Add support for SpriteKit

## [0.1.0](https://github.com/zilmarinen/Lattice/releases/tag/0.1.0) (13/09/2025)

- Introduce Tile entities

    - `TriangularEntity`
    - `HexagonalEntity`

- Introduce Triangle Grid hierarchy
    
    - `TriangularGrid`
    - `TriangularRegion`
    - `TriangularChunk`

- Introduce Hexagon Grid hierarchy
    
    - `HexagonalGrid`
    - `HexagonalRegion`
    - `HexagonalChunk`
    
- Introduce Components

    - `DataStoreComponent`
    - `SoilableComponent`
    
- Introduce Data Store protocols

    - `DataStore`
    - `DataStoreChunk`
    - `DataStoreStitch`
    - `DataStoreWeave`
    - `DataStoreWedge`
    - `DataStoreValue`
    
- Introduce Triangular Data Store

    - `TriangularDataStore`
    - `TriangularDataStoreRegion`
    - `TriangularDataStoreChunk`
    - `TriangularDataStoreTile`
    
- Introduce Hexagonal Data Store

    - `HexagonalDataStore`
    - `HexagonalDataStoreRegion`
    - `HexagonalDataStoreChunk`
    - `HexagonalDataStoreTile`
    
- Introduce Triangular Lattice

    - `TriangularLattice`
    - `TriangularLatticeSlice`
    
- Introduce Hexagonal Lattice

    - `HexagonalLattice`
    - `HexagonalLatticeSlice`
 
