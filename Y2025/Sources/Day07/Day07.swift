import AdventOfCode

enum Square {
    case splitter
    case space(Int)

    var count: Int {
        switch self {
        case .splitter: 0
        case let .space(count): count
        }
    }

    static func += (lhs: inout Self, value: Int) {
        switch lhs {
        case .splitter:
            break
        case let .space(count):
            lhs = .space(count + value)
        }
    }
}

struct Day07: AdventDay {
    private func parse(character: Character) -> Square {
        switch character {
        case "S": Square.space(1)
        case "^": Square.splitter
        case ".": Square.space(0)
        default: fatalError()
        }
    }

    private func parse(input: String) -> [[Square]] {
        input
            .split(separator: "\n")
            .map { Array($0).map(parse(character:)) }
    }

    func part1(input: String) throws -> Int {
        var grid = parse(input: input)
        var result = 0
        for i in 0..<grid.count - 1 {
            for j in 0..<grid[i].count {
                if case let .space(count) = grid[i][j], count > 0 {
                    switch grid[i + 1][j] {
                    case .splitter:
                        result += 1
                        grid[i + 1][j - 1] += 1
                        grid[i + 1][j + 1] += 1
                    case .space:
                        grid[i + 1][j] += 1
                    }
                }
            }
        }
        return result
    }

    func part2(input: String) throws -> Int {
        var grid = parse(input: input)
        for i in 0..<grid.count - 1 {
            for j in 0..<grid[i].count {
                if case let .space(count) = grid[i][j], count > 0 {
                    switch grid[i + 1][j] {
                    case .splitter:
                        grid[i + 1][j - 1] += count
                        grid[i + 1][j + 1] += count
                    case .space:
                        grid[i + 1][j] += count
                    }
                }
            }
        }
        return grid[grid.count - 1].reduce(0) { $0 + $1.count }
    }
}
