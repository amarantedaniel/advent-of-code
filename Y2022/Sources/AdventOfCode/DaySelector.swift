import AdventDay
import Day01
import Day02

struct DaySelector {
    let all: [any AdventDay] = [
        Day01(),
        Day02()
    ]

    func get(_ number: Int?) throws -> [any AdventDay] {
        guard let number else { return all }
        guard 1...25 ~= number else { throw AdventError.invalidDay }
        return [all[number - 1]]
    }
}
