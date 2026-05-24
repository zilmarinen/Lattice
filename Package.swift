// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Lattice",
    platforms: [.macOS(.v15),
                .iOS(.v17)],
    products: [
        .library(name: "Lattice",
                 targets: ["Lattice"])
    ],
    dependencies: [
        .package(path: "../Deltille"),
        .package(url: "https://github.com/nicklockwood/Euclid.git",
                 branch: "main")
    ],
    targets: [
        .target(name: "Lattice",
                dependencies: ["Deltille",
                               "Euclid"]),
        .testTarget(name: "LatticeTests",
                    dependencies: ["Deltille",
                                   "Euclid",
                                   "Lattice"])
    ]
)
