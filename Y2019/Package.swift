// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Y2019",
    products: [
        .library(name: "Day01", targets: ["Day01"]),
        .library(name: "Day02", targets: ["Day02"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "Day01", dependencies: []),
        .target(name: "Day02", dependencies: []),
        .testTarget(name: "Day01Tests", dependencies: ["Day01"], resources: [.process("Input")]),
        .testTarget(name: "Day02Tests", dependencies: ["Day02"], resources: [.process("Input")]),
    ])
