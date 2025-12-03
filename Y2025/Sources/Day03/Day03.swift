import AdventOfCode

struct Day03: AdventDay {
    private func parse(input: String) -> [[Int]] {
        input
            .split(separator: "\n")
            .map { $0.compactMap(\.wholeNumberValue) }
    }

    func part1(input: String) throws -> Int {
        let banks = parse(input: input)
        return solve(banks: banks, numberLength: 2)
    }

    func part2(input: String) throws -> Int {
        let banks = parse(input: input)
        return solve(banks: banks, numberLength: 12)
    }

    private func solve(banks: [[Int]], numberLength: Int) -> Int {
        var result = 0
        for bank in banks {
            var numbers = Array(repeating: 0, count: numberLength)
            for i in 0..<bank.count {
                var updateAll = false
                for j in 0..<numbers.count where i + j < bank.count {
                    let normalizedJ = j + max(0, (i + numbers.count) - bank.count)
                    if updateAll {
                        numbers[normalizedJ] = bank[i + j]
                    } else if numbers[normalizedJ] < bank[i + j] {
                        numbers[normalizedJ] = bank[i + j]
                        updateAll = true
                    }
                }
            }
            result += Int(numbers.map(\.description).joined(separator: ""))!
        }
        return result
    }
}
