// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftSpatial",
    platforms: [.macOS(.v15)],
    products: [
        .library(
            name: "SwiftSpatial",
            targets: ["SwiftSpatial"]),
    ],
    dependencies: [
        .package(url: "https://github.com/keyvariable/kvSIMD.swift.git", from: "1.0.3")
    ],
    targets: [
        .target(
            name: "SwiftSpatial"),
        .testTarget(
            name: "SwiftSpatialTests",
            dependencies: ["SwiftSpatial"]
        ),
    ]
)
