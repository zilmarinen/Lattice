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
[Regolith](https://github.com/zilmarinen/Regolith/) makes use of the concepts introduced by Deltille / Lattice to generate meshes for predefined tessellations of a triangle interior using [Ortho-Tiling](https://www.boristhebrave.com/2023/05/31/ortho-tiles/).

[Verdure](https://github.com/zilmarinen/Verdure/) implements additional mesh generation on top of Deltille / Lattice to create stylised foliage canopies constrained to a triangular grid.

# Credits

The Lattice framework is primarily the work of [Zack Brown](https://github.com/zilmarinen).
