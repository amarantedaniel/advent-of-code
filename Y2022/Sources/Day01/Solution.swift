import Foundation

func solve1(input: String) -> Int {
    input
        .components(separatedBy: "\n\n")
        .map { $0.split(separator: "\n").map { Int($0)! }.reduce(0, +) }
        .max()!
}

func solve2(input: String) -> Int {
    input
        .components(separatedBy: "\n\n")
        .map { $0.split(separator: "\n").map { Int($0)! }.reduce(0, +) }
        .sorted()
        .suffix(3)
        .reduce(0, +)
}
