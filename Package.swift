// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "assetmate",
    platforms: [.macOS(.v10_12)],
    products: [
        .executable(name: "assetmate", targets: ["AssetMate"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "0.2.0")),
    ],
    targets: [
        .target(
            name: "AssetMate",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        .testTarget(
            name: "AssetMateTests",
            dependencies: ["AssetMate"]
        ),
    ]
)
