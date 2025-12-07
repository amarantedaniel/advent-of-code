import AdventOfCode

enum Operator: String {
    case mul = "*"
    case sum = "+"
}

struct Day06: AdventDay {
    private func parsePart1(input: String) -> ([[Int]], [Operator]) {
        let rows = input.split(separator: "\n").map { row in
            row
                .components(separatedBy: .whitespaces)
                .filter { !$0.isEmpty }
        }
        let grid = rows.dropLast().map {
            $0.compactMap { Int($0) }
        }
        let operators = rows.last?.compactMap {
            Operator(rawValue: $0)
        }
        return (grid, operators ?? [])
    }

    private func parsePart2(input: String) -> ([[Int?]], [Operator]) {
        let rows = input.split(separator: "\n")

        let grid = rows
            .dropLast()
            .map { row in
                Array(row).map(\.wholeNumberValue)
            }

        let operators = rows
            .last?
            .components(separatedBy: .whitespaces)
            .filter { !$0.isEmpty }
            .compactMap {
                Operator(rawValue: $0)
            }
        return (grid, operators ?? [])
    }

    func part1(input: String) throws -> Int {
        var result = 0
        let (grid, operations) = parsePart1(input: input)
        let length = grid[0].count
        for j in 0..<length {
            let numbers = (0..<grid.count).map { grid[$0][j] }
            result += execute(operator: operations[j], numbers: numbers)
        }
        return result
    }

    func part2(input: String) throws -> Int {
        var result = 0
        let (grid, operations) = parsePart2(input: input)
        var numbers: [Int] = []
        let length = grid[0].count
        var z = operations.count - 1
        for j in stride(from: length - 1, to: -1, by: -1) {
            var number = 0
            for i in 0..<grid.count {
                if let num = grid[i][j] {
                    number = number * 10 + num
                }
            }
            if number == 0 {
                result += execute(operator: operations[z], numbers: numbers)
                z -= 1
                numbers = []
            } else {
                numbers.append(number)
            }
        }
        result += execute(operator: operations[z], numbers: numbers)
        return result
    }

    private func execute(operator: Operator, numbers: [Int]) -> Int {
        switch `operator` {
        case .mul:
            numbers.reduce(1, *)
        case .sum:
            numbers.reduce(0, +)
        }
    }
}
