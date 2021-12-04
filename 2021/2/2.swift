import Foundation

enum Direction {
    case forward(Int)
    case down(Int)
    case up(Int)
}

struct Position {
    var x: Int
    var y: Int
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

func process(directions: [Direction]) -> Position {
    return directions.reduce(into: Position(x: 0, y: 0)) { position, direction in
        switch direction {
        case .forward(let value):
            position.x += value
        case .up(let value):
            position.y -= value
        case .down(let value):
            position.y += value
        }
    }
}

let parser = Parser()
let input = try! String(contentsOfFile: "input.txt", encoding: .utf8)
let directions = parser.parseDirections(from: input)
let finalPosition = process(directions: directions)

print(finalPosition.x * finalPosition.y)
