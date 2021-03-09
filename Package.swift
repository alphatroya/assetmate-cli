// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "assetmate",
    platforms: [.macOS(.v10_12)],
    products: [
        .executable(name: "assetmate", targets: ["AssetMate"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "0.4.1")),
        .package(url: "https://github.com/jpsim/Yams", .upToNextMinor(from: "4.0.0")),
    ],
    targets: [
        .target(
            name: "AssetMate",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "Yams",
            ]
        ),
        .testTarget(
            name: "AssetMateTests",
            dependencies: ["AssetMate"]
        ),
    ]
)
