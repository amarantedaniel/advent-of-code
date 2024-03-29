import AdventDay
import ArgumentParser
import Foundation

@main
struct AdventOfCode: AsyncParsableCommand {
    @Option(help: "The day of the challenge. For December 1st, use '1'.")
    var day: Int?

    @Option(help: "1 for part 1, 2 for part 2")
    var part: Part?

    func run() async throws {
        let daySelector = DaySelector()
        var outputBuilder: OutputBuilder = TableOutputBuilder()
        for adventDay in try daySelector.get(day) {
            try run(day: adventDay, part: part, outputBuilder: &outputBuilder)
        }
        print(outputBuilder.build())
    }

    private func run(day: some AdventDay, part: Part?, outputBuilder: inout OutputBuilder) throws {
        let runner = try AdventDayRunner(day: day)
        outputBuilder.set(day: day.name)
        if let part {
            outputBuilder.set(result: runner.run(part: part), for: part)
        } else {
            outputBuilder.set(result: runner.run(part: .part1), for: .part1)
            outputBuilder.set(result: runner.run(part: .part2), for: .part2)
        }
    }
}
