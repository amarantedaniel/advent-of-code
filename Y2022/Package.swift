// swift-tools-version:5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Y2022",
    platforms: [.macOS(.v13)],
    products: [
        .library(name: "AdventDay", targets: ["AdventDay"]),
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
        .package(url: "https://github.com/apple/swift-collections.git", .upToNextMajor(from: "1.1.0")),
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMajor(from: "1.3.0"))
    ],
    targets: [
        .executableTarget(name: "AdventOfCode", dependencies: [
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
            .target(name: "AdventDay"),
            .target(name: "Day01"),
            .target(name: "Day02")
        ], resources: [
            .process("Input")
        ]),
        .target(name: "AdventDay", dependencies: []),
        .target(name: "Day01", dependencies: [
            .target(name: "AdventDay")
        ]),
        .target(name: "Day02", dependencies: [
            .target(name: "AdventDay")
        ]),
        .target(name: "Day03", dependencies: []),
        .target(name: "Day04", dependencies: []),
        .target(name: "Day05", dependencies: []),
        .target(name: "Day06", dependencies: []),
        .target(name: "Day07", dependencies: []),
        .target(name: "Day08", dependencies: []),
        .target(name: "Day09", dependencies: []),
        .target(name: "Day10", dependencies: []),
        .target(name: "Day11", dependencies: []),
        .target(name: "Day12", dependencies: [
            .product(name: "Collections", package: "swift-collections")
        ]),
        .target(name: "Day13", dependencies: []),
        .target(name: "Day14", dependencies: []),
        .target(name: "Day15", dependencies: []),
        .target(name: "Day16", dependencies: [
            .product(name: "Collections", package: "swift-collections")
        ]),
        .target(name: "Day17", dependencies: []),
        .target(name: "Day18", dependencies: []),
        .target(name: "Day19", dependencies: []),
        .target(name: "Day20", dependencies: []),
        .target(name: "Day21", dependencies: []),
        .target(name: "Day22", dependencies: []),
        .target(name: "Day23", dependencies: []),
        .target(name: "Day24", dependencies: []),
        .target(name: "Day25", dependencies: [])
    ]
)
