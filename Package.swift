// swift-tools-version:5.10

import PackageDescription

let package = Package(
    name: "assetmate",
    platforms: [.macOS(.v10_13)],
    products: [
        .executable(name: "assetmate", targets: ["AssetMate"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "1.0.0")
        ),
        .package(url: "https://github.com/jpsim/Yams", .upToNextMinor(from: "4.0.0")),
        .package(url: "https://github.com/marmelroy/Zip", branch: "master"),
    ],
    targets: [
        .executableTarget(
            name: "AssetMate",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "Yams",
                "Zip",
            ]
        ),
        .testTarget(
            name: "AssetMateTests",
            dependencies: ["AssetMate"]
        ),
    ]
)
