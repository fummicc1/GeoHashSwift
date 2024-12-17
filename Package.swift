// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GeoHash",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v15),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "GeoHashFramework",
            targets: ["GeoHashFramework"]
        ),
        .executable(
            name: "geohash",
            targets: ["GeoHashCLI"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-argument-parser",
            .upToNextMajor(from: "1.5.0")
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "GeoHashFramework"
        ),
        .executableTarget(
            name: "GeoHashCLI",
            dependencies: [
                "GeoHashFramework",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        .testTarget(
            name: "GeoHashFrameworkTests",
            dependencies: ["GeoHashFramework"]
        ),
    ]
)
