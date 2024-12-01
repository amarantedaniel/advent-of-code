import AdventOfCode

struct Day01: AdventDay {
    private func parse(input: String) -> ([Int], [Int]) {
        var left: [Int] = []
        var right: [Int] = []
        for line in input.split(separator: "\n") {
            let numbers = line.split(whereSeparator: \.isWhitespace)
            left.append(Int(numbers[0])!)
            right.append(Int(numbers[1])!)
        }
        return (left, right)
    }

    func part1(input: String) throws -> Int {
        let (left, right) = parse(input: input)
        return zip(left.sorted(), right.sorted()).reduce(0) { result, pair in
            result + abs(pair.0 - pair.1)
        }
    }

    func part2(input: String) throws -> Int {
        let (left, right) = parse(input: input)
        let counts = right.reduce(into: [Int: Int]()) { numbers, number in
            numbers[number, default: 0] += 1
        }
        return left.reduce(0) { result, number in
            result + number * counts[number, default: 0]
        }
    }
}
