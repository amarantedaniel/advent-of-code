import AdventOfCode

struct Day07: AdventDay {
    private func parse(input: String) -> [(Int, [Int])] {
        input.split(separator: "\n").map { line in
            let parts = line.split(separator: ":")
            return (
                testValue: Int(parts[0])!,
                numbers: parts[1].split(separator: " ").compactMap { Int($0) }
            )
        }
    }

    private func isValid1(result: Int, numbers: [Int]) -> Bool {
        if numbers.count == 1 {
            return numbers[0] == result
        }
        let sum = isValid1(
            result: result,
            numbers: [numbers[0] + numbers[1]] + numbers[2...]
        )
        let mul = isValid1(
            result: result,
            numbers: [numbers[0] * numbers[1]] + numbers[2...]
        )
        return sum || mul
    }

    private func isValid2(result: Int, numbers: [Int]) -> Bool {
        if numbers.count == 1 {
            return numbers[0] == result
        }
        let sum = isValid2(
            result: result,
            numbers: [numbers[0] + numbers[1]] + numbers[2...]
        )
        let mul = isValid2(
            result: result,
            numbers: [numbers[0] * numbers[1]] + numbers[2...]
        )
        let concat = isValid2(
            result: result,
            numbers: [Int("\(numbers[0])\(numbers[1])")!] + numbers[2...]
        )
        return sum || mul || concat
    }

    func part1(input: String) throws -> Int {
        parse(input: input)
            .filter { isValid1(result: $0.0, numbers: $0.1) }
            .map(\.0)
            .reduce(0, +)
    }

    func part2(input: String) throws -> Int {
        parse(input: input)
            .filter { isValid2(result: $0.0, numbers: $0.1) }
            .map(\.0)
            .reduce(0, +)
    }
}
