// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Y2018",
    products: [
        .library(name: "Day18", targets: ["Day18"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "Day18", dependencies: []),
        .testTarget(name: "Day18Tests", dependencies: ["Day18"], resources: [.process("Input")]),
    ])
