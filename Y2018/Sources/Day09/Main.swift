import AdventOfCode
import ArgumentParser
import Foundation

@main
struct Main: AsyncParsableCommand {
    @Option
    var part: String?

    func run() async throws {
        let solver = try Solver<Day09>(bundle: Bundle.module)
        await solver.solve(day: Day09(), part: Part(value: part))
    }
}