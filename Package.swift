// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-tendermint",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Tendermint",
            targets: ["Tendermint"]),
    ],
    dependencies: [
        .package(name: "ABCI", url: "https://github.com/CosmosSwift/swift-abci", .branch("main")),
        .package(name: "swift-crypto", url: "https://github.com/apple/swift-crypto.git", .upToNextMajor(from: "1.0.0")),
        .package(name: "swift-argument-parser", url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "0.3.1")),
        .package(name: "async-http-client", url: "https://github.com/swift-server/async-http-client.git", .upToNextMajor(from: "1.0.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Tendermint",
            dependencies: [
                .target(name: "Bech32"),
                .product(name: "ABCIMessages", package: "ABCI"),
                .product(name: "Crypto", package: "swift-crypto"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
            ]),
        .target(name: "Bech32"),
    ]
)
