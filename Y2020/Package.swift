// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Y2020",
    products: [
        .library(name: "Y2020D1", targets: ["Y2020D1"]),
        .library(name: "Y2020D2", targets: ["Y2020D2"]),
        .library(name: "Y2020D3", targets: ["Y2020D3"]),
        .library(name: "Y2020D4", targets: ["Y2020D4"]),
        .library(name: "Y2020D5", targets: ["Y2020D5"]),
        .library(name: "Y2020D6", targets: ["Y2020D6"]),
        .library(name: "Y2020D7", targets: ["Y2020D7"]),
        .library(name: "Y2020D8", targets: ["Y2020D8"]),
        .library(name: "Y2020D9", targets: ["Y2020D9"]),
        .library(name: "Y2020D10", targets: ["Y2020D10"]),
        .library(name: "Y2020D11", targets: ["Y2020D11"]),
        .library(name: "Y2020D12", targets: ["Y2020D12"]),
        .library(name: "Y2020D13", targets: ["Y2020D13"]),
        .library(name: "Y2020D14", targets: ["Y2020D14"]),
        .library(name: "Y2020D15", targets: ["Y2020D15"]),
        .library(name: "Y2020D16", targets: ["Y2020D16"]),
        .library(name: "Y2020D17", targets: ["Y2020D17"]),
        .library(name: "Y2020D18", targets: ["Y2020D18"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "Y2020D1", dependencies: []),
        .target(name: "Y2020D2", dependencies: []),
        .target(name: "Y2020D3", dependencies: []),
        .target(name: "Y2020D4", dependencies: []),
        .target(name: "Y2020D5", dependencies: []),
        .target(name: "Y2020D6", dependencies: []),
        .target(name: "Y2020D7", dependencies: []),
        .target(name: "Y2020D8", dependencies: []),
        .target(name: "Y2020D9", dependencies: []),
        .target(name: "Y2020D10", dependencies: []),
        .target(name: "Y2020D11", dependencies: []),
        .target(name: "Y2020D12", dependencies: []),
        .target(name: "Y2020D13", dependencies: []),
        .target(name: "Y2020D14", dependencies: []),
        .target(name: "Y2020D15", dependencies: []),
        .target(name: "Y2020D16", dependencies: []),
        .target(name: "Y2020D17", dependencies: []),
        .target(name: "Y2020D18", dependencies: []),
        .testTarget(name: "Y2020D1Tests", dependencies: ["Y2020D1"], resources: [.process("Input")]),
        .testTarget(name: "Y2020D2Tests", dependencies: ["Y2020D2"], resources: [.process("Input")]),
        .testTarget(name: "Y2020D3Tests", dependencies: ["Y2020D3"], resources: [.process("Input")]),
        .testTarget(name: "Y2020D4Tests", dependencies: ["Y2020D4"], resources: [.process("Input")]),
        .testTarget(name: "Y2020D5Tests", dependencies: ["Y2020D5"], resources: [.process("Input")]),
        .testTarget(name: "Y2020D6Tests", dependencies: ["Y2020D6"], resources: [.process("Input")]),
        .testTarget(name: "Y2020D7Tests", dependencies: ["Y2020D7"], resources: [.process("Input")]),
        .testTarget(name: "Y2020D8Tests", dependencies: ["Y2020D8"], resources: [.process("Input")]),
        .testTarget(name: "Y2020D9Tests", dependencies: ["Y2020D9"], resources: [.process("Input")]),
        .testTarget(name: "Y2020D10Tests", dependencies: ["Y2020D10"], resources: [.process("Input")]),
        .testTarget(name: "Y2020D11Tests", dependencies: ["Y2020D11"], resources: [.process("Input")]),
        .testTarget(name: "Y2020D12Tests", dependencies: ["Y2020D12"], resources: [.process("Input")]),
        .testTarget(name: "Y2020D13Tests", dependencies: ["Y2020D13"], resources: [.process("Input")]),
        .testTarget(name: "Y2020D14Tests", dependencies: ["Y2020D14"], resources: [.process("Input")]),
        .testTarget(name: "Y2020D15Tests", dependencies: ["Y2020D15"]),
        .testTarget(name: "Y2020D16Tests", dependencies: ["Y2020D16"], resources: [.process("Input")]),
        .testTarget(name: "Y2020D17Tests", dependencies: ["Y2020D17"], resources: [.process("Input")]),
        .testTarget(name: "Y2020D18Tests", dependencies: ["Y2020D18"], resources: [.process("Input")]),
    ])
