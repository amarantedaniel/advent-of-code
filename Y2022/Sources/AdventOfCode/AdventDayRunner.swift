import AdventDay
import Foundation

struct AdventDayRunner<Day: AdventDay> {
    private let day: Day
    private let input: String

    init(day: Day) throws {
        self.day = day
        let path = Bundle.module.path(forResource: day.name, ofType: "txt")
        guard let path, let input = try? String(contentsOfFile: path, encoding: .utf8) else {
            throw AdventError.missingInput
        }
        self.input = input
    }

    func run(part: Part) -> Result<AdventDayResult, Error> {
        switch part {
        case .part1:
            return runAndMeasure(block: { try day.part1(input: input) })
        case .part2:
            return runAndMeasure(block: { try day.part2(input: input) })
        }
    }

    func runAndMeasure(block: () throws -> Day.Output) -> Result<AdventDayResult, Error> {
        do {
            var result: Day.Output!
            let time = try ContinuousClock().measure {
                result = try block()
            }
            return .success(.init(result: result.description, duration: time))
        } catch {
            return .failure(error)
        }
    }
}
