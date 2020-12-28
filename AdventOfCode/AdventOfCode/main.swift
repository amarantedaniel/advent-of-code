import ArgumentParser
import Foundation
import Y2020D1
import Y2020D2

struct AdventOfCode: ParsableCommand {
    @Argument var inputFile: String

    @Option(name: .shortAndLong)
    var year: Int

    @Option(name: .shortAndLong)
    var day: Int

    @Option(name: .shortAndLong)
    var solution: Int

    mutating func run() throws {
        guard let input = try? String(contentsOfFile: inputFile) else {
            throw ValidationError("Couldn't read from '\(inputFile)'!")
        }
        guard 2015 ... 2020 ~= year else { throw ValidationError("Invalid year") }
        guard 1 ... 25 ~= day else { throw ValidationError("Invalid day") }
        guard 1 ... 2 ~= solution else { throw ValidationError("Invalid solution") }
        switch (year, day, solution) {
        case (2020, 1, 1):
            print(Y2020D1.solve1(input) ?? "")
        case (2020, 1, 2):
            print(Y2020D1.solve2(input) ?? "")
        case (2020, 2, 1):
            print(Y2020D2.solve1(input))
        case (2020, 2, 2):
            print(Y2020D2.solve2(input))
        default:
            print("Solution unavailable")
        }
    }
}

AdventOfCode.main()
