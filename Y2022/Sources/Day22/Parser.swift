import Foundation

struct Cube {
    let top: [[Square]]
    let bottom: [[Square]]
    let front: [[Square]]
    let back: [[Square]]
    let left: [[Square]]
    let right: [[Square]]
}

enum Parser {
    static func parseCube(input: String) -> (Cube, [Move]) {
        let components = input.components(separatedBy: "\n\n")
        let maze = parse(maze: components[0])
        let cube = buildCube(maze: maze)
        let moves = parse(movements: components[1])
        return (cube, moves)
    }

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

    static func buildCube(maze: [[Square]]) -> Cube {
        let firstRow = maze[0..<maze.count / 3]
        let secondRow = maze[maze.count / 3..<maze.count / 3 * 2]
        let thirdRow = maze[(maze.count / 3 * 2)...]

        var result1: [[Square]] = []
        var result2: [[Square]] = []
        var result3: [[Square]] = []
        var result4: [[Square]] = []
        for row in firstRow {
            result1.append(Array(row[0..<row.count / 4]))
            result2.append(Array(row[row.count / 4..<row.count / 4 * 2]))
            result3.append(Array(row[row.count / 4 * 2..<row.count / 4 * 3]))
            result4.append(Array(row[row.count / 4 * 3..<row.count / 4 * 4]))
        }

        var result5: [[Square]] = []
        var result6: [[Square]] = []
        var result7: [[Square]] = []
        var result8: [[Square]] = []
        for row in secondRow {
            result5.append(Array(row[0..<row.count / 4]))
            result6.append(Array(row[row.count / 4..<row.count / 4 * 2]))
            result7.append(Array(row[row.count / 4 * 2..<row.count / 4 * 3]))
            result8.append(Array(row[row.count / 4 * 3..<row.count / 4 * 4]))
        }

        var result9: [[Square]] = []
        var result10: [[Square]] = []
        var result11: [[Square]] = []
        var result12: [[Square]] = []
        for row in thirdRow {
            result9.append(Array(row[0..<row.count / 4]))
            result10.append(Array(row[row.count / 4..<row.count / 4 * 2]))
            result11.append(Array(row[row.count / 4 * 2..<row.count / 4 * 3]))
            result12.append(Array(row[row.count / 4 * 3..<row.count / 4 * 4]))
        }
        return Cube(
            top: result3,
            bottom: result11,
            front: result7,
            back: result5,
            left: result6,
            right: result12
        )
    }
}
