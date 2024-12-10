// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import PackageDescription

let package = Package(
    name: "AdventOfCode",
    platforms: [.macOS(.v15)],
    products: makeExecutableProducts() + [
        .library(name: "AdventOfCode", targets: ["AdventOfCode"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", exact: "1.5.0"),
        .package(url: "https://github.com/apple/swift-collections.git", exact: "1.1.4")
    ],
    targets: makeExecutableTargets() + [
        .target(name: "AdventOfCode")
    ]
)

private func makeExecutableProducts() -> [Product] {
    return (1...25).map {
        String(format: "Day%02d", $0)
    }
    .map { name in
        Product.executable(name: name, targets: [name])
    }
}

private func makeExecutableTargets() -> [Target] {
    return (1...25).map {
        String(format: "Day%02d", $0)
    }
    .map { name in
        .executableTarget(
            name: name,
            dependencies: [
                .target(name: "AdventOfCode"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Collections", package: "swift-collections")
            ],
            resources: [.process("input.txt")]
        )
    }
}
