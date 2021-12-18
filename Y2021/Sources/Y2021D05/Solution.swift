import Foundation

struct Point: Equatable, CustomStringConvertible {
    var x: Int
    var y: Int

    var description: String { return "(\(x), \(y))" }
}

struct Grid: CustomStringConvertible {
    var matrix: [[Int]] = Array(repeating: Array(repeating: 0, count: 1000), count: 1000)

    mutating func addLine(from: Point, to: Point) {
        var current = from
        while current != to {
            matrix[current.y][current.x] += 1
            if to.y < current.y {
                current.y -= 1
            }
            if to.y > current.y {
                current.y += 1
            }
            if to.x < current.x {
                current.x -= 1
            }
            if to.x > current.x {
                current.x += 1
            }
        }
        matrix[current.y][current.x] += 1
    }

    func calculateResult() -> Int {
        var count = 0
        for row in matrix {
            for point in row where point > 1 {
                count += 1
            }
        }
        return count
    }

    var description: String {
        var text = ""
        for row in matrix {
            for point in row {
                text += point.description
            }
            text += "\n"
        }
        return text
    }
}

func solve2(input: String) -> Int {
    var grid = Grid()

    for line in input.split(separator: "\n") {
        let points = line
            .components(separatedBy: " -> ")
            .map { $0.split(separator: ",").compactMap { Int($0) } }
            .map { Point(x: $0[0], y: $0[1]) }

        grid.addLine(from: points[0], to: points[1])
    }
    return grid.calculateResult()
}
