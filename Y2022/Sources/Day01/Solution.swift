import AdventDay
import Foundation

public func solve1(input: String) -> Int {
    input
        .components(separatedBy: "\n\n")
        .map { $0.split(separator: "\n").map { Int($0)! }.reduce(0, +) }
        .max()!
}

public func solve2(input: String) -> Int {
    input
        .components(separatedBy: "\n\n")
        .map { $0.split(separator: "\n").map { Int($0)! }.reduce(0, +) }
        .sorted()
        .suffix(3)
        .reduce(0, +)
}

public struct Day01: AdventDay {
    public init() {}

    public func part1(input: String) throws -> Int {
        input
            .components(separatedBy: "\n\n")
            .map { $0.split(separator: "\n").map { Int($0)! }.reduce(0, +) }
            .max()!
    }

    public func part2(input: String) throws -> Int {
        input
            .components(separatedBy: "\n\n")
            .map { $0.split(separator: "\n").map { Int($0)! }.reduce(0, +) }
            .sorted()
            .suffix(3)
            .reduce(0, +)
    }
}
