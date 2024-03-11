import AdventDay
import ArgumentParser
import Foundation

enum Part: ExpressibleByArgument {
    init?(argument: String) {
        switch Int(argument) {
        case 1:
            self = .part1
        case 2:
            self = .part2
        default:
            self = .both
        }
    }

    case part1
    case part2
    case both
}

@main
struct AdventOfCode: AsyncParsableCommand {
    @Option(help: "The day of the challenge. For December 1st, use '1'.")
    var day: Int?

    @Option(help: "1 for part 1, 2 for part 2")
    var part: Part = .both

    func run() async throws {
        let daySelector = DaySelector()
        if let day {
            try run(day: daySelector.get(day), part: part)
            return
        }
        for day in daySelector.all {
            try run(day: day, part: part)
        }
    }

    private func run(day: some AdventDay, part: Part) throws {
        let runner = try AdventDayRunner(day: day)
        runner.run(part: part)
    }
}
