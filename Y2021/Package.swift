// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Y2021",
    products: [
        .library(name: "Y2021D1", targets: ["Y2021D1"]),
        .library(name: "Y2021D2", targets: ["Y2021D2"]),
        .library(name: "Y2021D3", targets: ["Y2021D3"]),
        .library(name: "Y2021D4", targets: ["Y2021D4"]),
        .library(name: "Y2021D5", targets: ["Y2021D5"]),
        .library(name: "Y2021D6", targets: ["Y2021D6"]),
        .library(name: "Y2021D7", targets: ["Y2021D7"]),
        .library(name: "Y2021D8", targets: ["Y2021D8"]),
        .library(name: "Y2021D9", targets: ["Y2021D9"]),
        .library(name: "Y2021D10", targets: ["Y2021D10"]),
        .library(name: "Y2021D11", targets: ["Y2021D11"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "Y2021D1", dependencies: []),
        .target(name: "Y2021D2", dependencies: []),
        .target(name: "Y2021D3", dependencies: []),
        .target(name: "Y2021D4", dependencies: []),
        .target(name: "Y2021D5", dependencies: []),
        .target(name: "Y2021D6", dependencies: []),
        .target(name: "Y2021D7", dependencies: []),
        .target(name: "Y2021D8", dependencies: []),
        .target(name: "Y2021D9", dependencies: []),
        .target(name: "Y2021D10", dependencies: []),
        .target(name: "Y2021D11", dependencies: []),
        .testTarget(name: "Y2021D1Tests", dependencies: ["Y2021D1"], resources: [.process("Input")]),
        .testTarget(name: "Y2021D2Tests", dependencies: ["Y2021D2"], resources: [.process("Input")]),
        .testTarget(name: "Y2021D3Tests", dependencies: ["Y2021D3"], resources: [.process("Input")]),
        .testTarget(name: "Y2021D4Tests", dependencies: ["Y2021D4"], resources: [.process("Input")]),
        .testTarget(name: "Y2021D5Tests", dependencies: ["Y2021D5"], resources: [.process("Input")]),
        .testTarget(name: "Y2021D6Tests", dependencies: ["Y2021D6"], resources: [.process("Input")]),
        .testTarget(name: "Y2021D7Tests", dependencies: ["Y2021D7"], resources: [.process("Input")]),
        .testTarget(name: "Y2021D8Tests", dependencies: ["Y2021D8"], resources: [.process("Input")]),
        .testTarget(name: "Y2021D9Tests", dependencies: ["Y2021D9"], resources: [.process("Input")]),
        .testTarget(name: "Y2021D10Tests", dependencies: ["Y2021D10"], resources: [.process("Input")]),
        .testTarget(name: "Y2021D11Tests", dependencies: ["Y2021D11"], resources: [.process("Input")]),
    ])
