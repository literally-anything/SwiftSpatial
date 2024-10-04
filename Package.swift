// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "SwiftSpatial",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "SwiftSpatial",
            targets: ["SwiftSpatial"])
    ],
    dependencies: [
        .package(url: "https://github.com/keyvariable/kvSIMD.swift.git", from: "1.0.3"),
        .package(url: "https://github.com/apple/swift-numerics", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-testing.git", branch: "main"),
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "SwiftSpatial",
            dependencies: [
                .product(name: "kvSIMD", package: "kvSIMD.swift"),
                .product(name: "RealModule", package: "swift-numerics")
            ],
            swiftSettings: [
                .swiftLanguageMode(.v6),
                .enableUpcomingFeature("InternalImportsByDefault"),
                .unsafeFlags(["-O", "-whole-module-optimization"], .when(configuration: .release)),
                .unsafeFlags(["-Onone"], .when(configuration: .debug))
            ]
        ),
        .testTarget(
            name: "SwiftSpatialTests",
            dependencies: [
                "SwiftSpatial",
                .product(name: "Testing", package: "swift-testing")
            ]
        ),
    ]
)
