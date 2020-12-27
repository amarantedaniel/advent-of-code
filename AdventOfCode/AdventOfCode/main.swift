import ArgumentParser

struct AdventOfCode: ParsableCommand {
    @Option(name: .shortAndLong)
    var year: Int = 2020

    @Option(name: .shortAndLong)
    var day: Int = 1

    mutating func run() throws {
        print("year: \(year)")
        print("day: \(day)")
    }
}

AdventOfCode.main()
