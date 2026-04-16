[![Platforms](https://img.shields.io/badge/platforms-iOS%20|%20Mac-lightgray.svg)]()
[![Swift 6.1](https://img.shields.io/badge/swift-6.1-red.svg?style=flat)](https://developer.apple.com/swift)
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-red?style=flat)](https://www.swift.org/documentation/package-manager/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://opensource.org/licenses/MIT)

- [Introduction](#lattice)
- [Installation](#installation)
- [Implementation](#implementation)
- [Examples](#examples)
- [Credits](#credits)

# Lattice
Lattice is a Swift library for modeling hexagonal and triangular grid lattices as efficient, hierarchical data structures. It is designed to persist values at each vertex of a uniform grid, making it ideal for simulations, procedural generation and spatial data processing.

Lattice provides a structured way to represent grid-based data using either triangular or hexagonal topologies. It combines:

 - Efficient spatial partitioning via chunking
 - Hierarchical invalidation to minimize unnecessary computation (dirty propagation)
 - Unified triangular representation across both lattice types
 - Interoperability between coordinate systems

Built with performance and extensibility in mind, Lattice enables you to build custom behaviors on top of a consistent and efficient core.

## Features

- Dual Grid Support
 - Native support for both hexagonal and triangular lattices
- Hierarchical Chunking
 - Organize data into regions, chunks, and tiles
 - Optimized for fast lookup and localized updates
- Dirty State Propagation
 - Automatically mark regions and chunks as dirty when values change
 - Efficient propagation through the hierarchy for recalculation or rendering
- Coordinate Conversion
 - Seamless conversion between hexagonal and triangular coordinate systems
- Test Coverage
 - Unit tested implementations for data stores and lattice types

# Installation
To install using Swift Package Manager, add this to the `dependencies:` section in your Package.swift file:

```swift
.package(url: "https://github.com/zilmarinen/Lattice.git", branch: "main"),
```

## Dependencies
[Deltille](https://github.com/zilmarinen/deltille) is a Swift library for working with hexagonal and triangular grid systems.
[Euclid](https://github.com/nicklockwood/Euclid) is a Swift library for creating and manipulating 3D geometry and is used extensively within this project for mesh generation and vector operations.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

# Implementation

# Examples

# Credits

The Lattice framework is primarily the work of [Zack Brown](https://github.com/zilmarinen).
