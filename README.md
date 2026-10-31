# Lattice

[![Platforms](https://img.shields.io/badge/platforms-iOS%20|%20Mac-lightgray.svg)]()
[![Swift 6.1](https://img.shields.io/badge/swift-6.1-red.svg?style=flat)](https://developer.apple.com/swift)
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-red?style=flat)](https://www.swift.org/documentation/package-manager/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://opensource.org/licenses/MIT)

Lattice is a Swift library for modeling hexagonal and triangular grid lattices as efficient, hierarchical data structures. It is designed to persist values at each vertex of a uniform grid, making it ideal for simulations, procedural generation, and spatial data processing.

## Features

- **Dual Grid Support** - Native support for both hexagonal and triangular lattices
- **Hierarchical Chunking** - Organize data into regions, chunks, and tiles; optimized for fast lookup and localized updates
- **Dirty State Propagation** - Automatically mark regions and chunks as dirty when values change; efficient propagation through the hierarchy for recalculation or rendering
- **Coordinate Conversion** - Seamless conversion between hexagonal and triangular coordinate systems
- **Test Coverage** - Unit tested implementations for data stores and lattice types

## Installation

To install using Swift Package Manager, add this to the `dependencies:` section in your `Package.swift` file:

```swift
.package(url: "https://github.com/zilmarinen/Lattice.git", branch: "main"),
```

## Dependencies

- [Deltille](https://github.com/zilmarinen/deltille) - a Swift library for working with hexagonal and triangular grid systems
- [Euclid](https://github.com/nicklockwood/Euclid) - a Swift library for creating and manipulating 3D geometry and is used extensively within this project for mesh generation and vector operations

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.
