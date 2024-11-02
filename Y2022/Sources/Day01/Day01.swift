import AdventOfCode

struct Day01: AdventDay {
    public init() {}

    func part1(input: String) throws -> Int {
        input
            .components(separatedBy: "\n\n")
            .map { $0.split(separator: "\n").map { Int($0)! }.reduce(0, +) }
            .max()!
    }

    func part2(input: String) throws -> Int {
        input
            .components(separatedBy: "\n\n")
            .map { $0.split(separator: "\n").map { Int($0)! }.reduce(0, +) }
            .sorted()
            .suffix(3)
            .reduce(0, +)
    }
}
