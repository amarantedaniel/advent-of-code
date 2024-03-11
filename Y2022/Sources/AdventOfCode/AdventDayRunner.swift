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

    func run(part: Part) {
        print("Running day \(day.name)")
        switch part {
        case .part1:
            runPart1()
        case .part2:
            runPart2()
        case .both:
            runPart1()
            runPart2()
        }
    }

    func runPart1() {

        do {
            let result = try day.part1(input: input)
            print("Part 1: \(result)")
        } catch {
            print("Part 1: \(error)")
        }
    }

    func runPart2() {
        do {
            let result = try day.part2(input: input)
            print("Part 2: \(result)")
        } catch {
            print("Part 2: \(error)")
        }
    }
}
