// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "ios-color-mate",
    platforms: [.macOS(.v10_12)],
    products: [
        .executable(name: "ios-color-mate", targets: ["ios-color-mate"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "0.0.2")),
    ],
    targets: [
        .target(
            name: "ios-color-mate",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        .testTarget(
            name: "ios-color-mateTests",
            dependencies: ["ios-color-mate"]
        ),
    ]
)
