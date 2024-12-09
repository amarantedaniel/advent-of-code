import AdventOfCode

struct Day01: AdventDay {
    private func calculateRequiredFuel(for mass: Int) -> Int {
        let fuel = mass / 3 - 2
        if fuel > 0 {
            return fuel + calculateRequiredFuel(for: fuel)
        }
        return 0
    }

    func part1(input: String) throws -> Int {
        throw AdventError.notImplemented
    }

    func part2(input: String) throws -> Int {
        input
            .split(separator: "\n")
            .compactMap { Int($0) }
            .map(calculateRequiredFuel(for:)).reduce(0, +)
    }
}
