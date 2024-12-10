import AdventOfCode

enum Direction {
    case forward(Int)
    case down(Int)
    case up(Int)
}

struct Position {
    var x: Int
    var y: Int
    var aim: Int

    static let zero = Position(x: 0, y: 0, aim: 0)
}

struct Parser {
    func parseDirections(from input: String) -> [Direction] {
        return input
            .split(separator: "\n")
            .map(parseDirection(from:))
    }

    private func parseDirection(from line: Substring) -> Direction {
        let elements = line.split(separator: " ")
        switch elements[0] {
        case "forward":
            return .forward(Int(elements[1])!)
        case "down":
            return .down(Int(elements[1])!)
        case "up":
            return .up(Int(elements[1])!)
        default:
            fatalError()
        }
    }
}

struct Day02: AdventDay {
    func processPartOne(directions: [Direction]) -> Position {
        return directions.reduce(into: .zero) { position, direction in
            switch direction {
            case let .forward(value):
                position.x += value
            case let .up(value):
                position.y -= value
            case let .down(value):
                position.y += value
            }
        }
    }

    func processPartTwo(directions: [Direction]) -> Position {
        return directions.reduce(into: .zero) { position, direction in
            switch direction {
            case let .forward(value):
                position.x += value
                position.y += position.aim * value
            case let .up(value):
                position.aim -= value
            case let .down(value):
                position.aim += value
            }
        }
    }

    func part1(input: String) -> Int {
        let parser = Parser()
        let directions = parser.parseDirections(from: input)
        let finalPosition = processPartOne(directions: directions)
        return finalPosition.x * finalPosition.y
    }

    func part2(input: String) -> Int {
        let parser = Parser()
        let directions = parser.parseDirections(from: input)
        let finalPosition = processPartTwo(directions: directions)
        return finalPosition.x * finalPosition.y
    }
}
