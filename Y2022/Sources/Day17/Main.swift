import AdventOfCode
import ArgumentParser
import Foundation

@main
struct Main: AsyncParsableCommand {
    @Option
    var part: String?

    func run() async throws {
        let solver = try Solver<Day17>(bundle: Bundle.module)
        await solver.solve(day: Day17(), part: Part(value: part))
    }
}
