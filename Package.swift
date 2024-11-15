// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KReader",
    platforms: [.iOS(.v18), .macOS(.v10_15), .tvOS(.v13), .visionOS(.v1), .watchOS(.v6)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "KReader",
            targets: ["KReader"]),
    ],
    dependencies: [
        .package(path: "../../KModel"),
        .package(path: "../../FormBuilder"),
        .package(path: "../../BLEReaderUtility")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "KReader",
            dependencies: [
                .product(name: "KModel", package: "KModel"),
                .product(name: "FormBuilder", package: "FormBuilder"),
                .product(name: "BLEReaderUtility", package: "BLEReaderUtility")
            ],
            resources: [.process("Resources")]
        )
    ]
)
