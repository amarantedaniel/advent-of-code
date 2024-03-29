// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Y2021",
    products: [
        .library(name: "Day01", targets: ["Day01"]),
        .library(name: "Day02", targets: ["Day02"]),
        .library(name: "Day03", targets: ["Day03"]),
        .library(name: "Day04", targets: ["Day04"]),
        .library(name: "Day05", targets: ["Day05"]),
        .library(name: "Day06", targets: ["Day06"]),
        .library(name: "Day07", targets: ["Day07"]),
        .library(name: "Day08", targets: ["Day08"]),
        .library(name: "Day09", targets: ["Day09"]),
        .library(name: "Day10", targets: ["Day10"]),
        .library(name: "Day11", targets: ["Day11"]),
        .library(name: "Day12", targets: ["Day12"]),
        .library(name: "Day13", targets: ["Day13"]),
        .library(name: "Day14", targets: ["Day14"]),
        .library(name: "Day15", targets: ["Day15"]),
        .library(name: "Day16", targets: ["Day16"]),
        .library(name: "Day17", targets: ["Day17"]),
        .library(name: "Day18", targets: ["Day18"]),
        .library(name: "Day19", targets: ["Day19"]),
        .library(name: "Day20", targets: ["Day20"]),
        .library(name: "Day21", targets: ["Day21"]),
        .library(name: "Day22", targets: ["Day22"]),
        .library(name: "Day23", targets: ["Day23"]),
        .library(name: "Day24", targets: ["Day24"]),
        .library(name: "Day25", targets: ["Day25"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-collections.git", branch: "release/1.1")
    ],
    targets: [
        .target(name: "Day01", dependencies: []),
        .target(name: "Day02", dependencies: []),
        .target(name: "Day03", dependencies: []),
        .target(name: "Day04", dependencies: []),
        .target(name: "Day05", dependencies: []),
        .target(name: "Day06", dependencies: []),
        .target(name: "Day07", dependencies: []),
        .target(name: "Day08", dependencies: []),
        .target(name: "Day09", dependencies: []),
        .target(name: "Day10", dependencies: []),
        .target(name: "Day11", dependencies: []),
        .target(name: "Day12", dependencies: []),
        .target(name: "Day13", dependencies: []),
        .target(name: "Day14", dependencies: []),
        .target(name: "Day15", dependencies: [
            .product(name: "Collections", package: "swift-collections")
        ]),
        .target(name: "Day16", dependencies: []),
        .target(name: "Day17", dependencies: []),
        .target(name: "Day18", dependencies: []),
        .target(name: "Day19", dependencies: []),
        .target(name: "Day20", dependencies: []),
        .target(name: "Day21", dependencies: []),
        .target(name: "Day22", dependencies: []),
        .target(name: "Day23", dependencies: [
            .product(name: "Collections", package: "swift-collections")
        ]),
        .target(name: "Day24", dependencies: []),
        .target(name: "Day25", dependencies: []),
        .testTarget(name: "Day01Tests", dependencies: ["Day01"], resources: [.process("Input")]),
        .testTarget(name: "Day02Tests", dependencies: ["Day02"], resources: [.process("Input")]),
        .testTarget(name: "Day03Tests", dependencies: ["Day03"], resources: [.process("Input")]),
        .testTarget(name: "Day04Tests", dependencies: ["Day04"], resources: [.process("Input")]),
        .testTarget(name: "Day05Tests", dependencies: ["Day05"], resources: [.process("Input")]),
        .testTarget(name: "Day06Tests", dependencies: ["Day06"], resources: [.process("Input")]),
        .testTarget(name: "Day07Tests", dependencies: ["Day07"], resources: [.process("Input")]),
        .testTarget(name: "Day08Tests", dependencies: ["Day08"], resources: [.process("Input")]),
        .testTarget(name: "Day09Tests", dependencies: ["Day09"], resources: [.process("Input")]),
        .testTarget(name: "Day10Tests", dependencies: ["Day10"], resources: [.process("Input")]),
        .testTarget(name: "Day11Tests", dependencies: ["Day11"], resources: [.process("Input")]),
        .testTarget(name: "Day12Tests", dependencies: ["Day12"], resources: [.process("Input")]),
        .testTarget(name: "Day13Tests", dependencies: ["Day13"], resources: [.process("Input")]),
        .testTarget(name: "Day14Tests", dependencies: ["Day14"], resources: [.process("Input")]),
        .testTarget(name: "Day15Tests", dependencies: ["Day15"], resources: [.process("Input")]),
        .testTarget(name: "Day16Tests", dependencies: ["Day16"], resources: [.process("Input")]),
        .testTarget(name: "Day17Tests", dependencies: ["Day17"], resources: [.process("Input")]),
        .testTarget(name: "Day18Tests", dependencies: ["Day18"], resources: [.process("Input")]),
        .testTarget(name: "Day19Tests", dependencies: ["Day19"], resources: [.process("Input")]),
        .testTarget(name: "Day20Tests", dependencies: ["Day20"], resources: [.process("Input")]),
        .testTarget(name: "Day21Tests", dependencies: ["Day21"], resources: [.process("Input")]),
        .testTarget(name: "Day22Tests", dependencies: ["Day22"], resources: [.process("Input")]),
        .testTarget(name: "Day23Tests", dependencies: ["Day23"], resources: [.process("Input")]),
        .testTarget(name: "Day24Tests", dependencies: ["Day24"], resources: [.process("Input")]),
        .testTarget(name: "Day25Tests", dependencies: ["Day25"], resources: [.process("Input")]),
    ])
