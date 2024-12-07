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

    private func isValid1(result: Int, acc: Int, numbers: ArraySlice<Int>) -> Bool {
        guard let first = numbers.first else {
            return acc == result
        }
        return isValid1(
            result: result,
            acc: acc + first,
            numbers: numbers.dropFirst()
        ) || isValid1(
            result: result,
            acc: acc * first,
            numbers: numbers.dropFirst()
        )
    }

    private func isValid2(result: Int, acc: Int, numbers: ArraySlice<Int>) -> Bool {
        guard let first = numbers.first else {
            return acc == result
        }
        return isValid2(
            result: result,
            acc: acc + first,
            numbers: numbers.dropFirst()
        ) || isValid2(
            result: result,
            acc: acc * first,
            numbers: numbers.dropFirst()
        ) || isValid2(
            result: result,
            acc: Int("\(acc)\(first)")!,
            numbers: numbers.dropFirst()
        )
    }

    func part1(input: String) throws -> Int {
        parse(input: input)
            .filter { isValid1(result: $0.0, acc: 0, numbers: $0.1[...]) }
            .map(\.0)
            .reduce(0, +)
    }

    func part2(input: String) throws -> Int {
        parse(input: input)
            .filter { isValid2(result: $0.0, acc: 0, numbers: $0.1[...]) }
            .map(\.0)
            .reduce(0, +)
    }
}
