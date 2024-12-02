import AdventOfCode

struct Day02: AdventDay {
    private func parse(input: String) -> [[Int]] {
        input.split(separator: "\n").map { line in
            line.split(separator: " ").compactMap { Int($0) }
        }
    }

    private func isSafe(report: [Int]) -> Bool {
        let increasing = report[1] > report[0]
        for i in 0..<report.count - 1 {
            if increasing {
                if !(1...3 ~= report[i + 1] - report[i]) {
                    return false
                }
            } else {
                if !(1...3 ~= report[i] - report[i + 1]) {
                    return false
                }
            }
        }
        return true
    }

    private func isSafeWhenRemovingLevel(report: [Int]) -> Bool {
        for i in 0..<report.count {
            var report = report
            report.remove(at: i)
            if isSafe(report: report) {
                return true
            }
        }
        return false
    }

    func part1(input: String) throws -> Int {
        let reports = parse(input: input)
        return reports.filter(isSafe(report:)).count
    }

    func part2(input: String) throws -> Int {
        let reports = parse(input: input)
        return reports.filter(isSafeWhenRemovingLevel(report:)).count
    }
}
