// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "SwiftSpatial",
    platforms: [
        .macOS(.v14),
        .custom("linux", versionString: "")
    ],
    products: [
        .library(
            name: "SwiftSpatial",
            targets: ["SwiftSpatial"]),
    ],
    dependencies: [
        .package(url: "https://github.com/keyvariable/kvSIMD.swift.git", from: "1.0.3"),
        .package(url: "https://github.com/apple/swift-testing.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "SwiftSpatial",
            dependencies: [
                .product(name: "kvSIMD", package: "kvSIMD.swift")
            ],
            swiftSettings: [
                .swiftLanguageVersion(.v6),
                .unsafeFlags(["-O", "-whole-module-optimization"], .when(configuration: .release)),
                .unsafeFlags(["-Onone"], .when(configuration: .debug)),
            ]
        ),
        .testTarget(
            name: "SwiftSpatialTests",
            dependencies: [
                "SwiftSpatial",
                .product(name: "Testing", package: "swift-testing"),
            ]
        ),
    ]
)
