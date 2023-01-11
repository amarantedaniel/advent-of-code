import Foundation

enum Parser {
    static func parse(input: String) -> ([[Square]], [Move]) {
        let components = input.components(separatedBy: "\n\n")
        let maze = parse(maze: components[0])
        let moves = parse(movements: components[1])
        return (maze, moves)
    }

    private static func parse(movements input: String) -> [Move] {
        let numbers = input.split(whereSeparator: \.isLetter).compactMap { Int($0) }
        let letters = input.split(whereSeparator: \.isNumber)
        var moves = zip(numbers, letters).flatMap { number, letter in
            [Move.walk(number), letter == "R" ? .right : .left]
        }
        moves.append(.walk(numbers.last!))
        return moves
    }

    private static func parse(maze: String) -> [[Square]] {
        let maze = maze.split(separator: "\n").reduce(into: []) { matrix, line in
            matrix.append(Array(line).compactMap(Square.init(rawValue:)))
        }
        let maxCount = maze.map(\.count).max()!
        var maze2: [[Square]] = []
        for line in maze {
            let array = Array(repeating: Square.outside, count: maxCount - line.count)
            maze2.append(line + array)
        }
        return maze2
    }
}
