import Foundation

struct Point {
    let x: Int
    let y: Int
}

struct Grid: CustomStringConvertible {
    var matrix: [[Int]] = Array(repeating: Array(repeating: 0, count: 1000), count: 1000)

    mutating func addLine(from: Point, to: Point) {
        if from.x == to.x {
            drawVerticalLine(x: from.x, from: from.y, to: to.y)
        } else if from.y == to.y {
            drawHorizontalLine(y: from.y, from: from.x, to: to.x)
        }
    }

    private mutating func drawVerticalLine(x: Int, from: Int, to: Int) {
        let sorted = [from, to].sorted()
        let range = sorted[0]...sorted[1]
        for y in range {
            matrix[y][x] += 1
        }
    }

    private mutating func drawHorizontalLine(y: Int, from: Int, to: Int) {
        let sorted = [from, to].sorted()
        let range = sorted[0]...sorted[1]
        for x in range {
            matrix[y][x] += 1
        }
    }

    func calculateResult() -> Int {
        var count = 0
        for y in 0..<matrix.count {
            for x in 0..<matrix[y].count {
                if matrix[y][x] > 1 {
                    count += 1
                }
            }
        }
        return count
    }

    var description: String {
        var text = ""
        for y in 0..<matrix.count {
            for x in 0..<matrix[y].count {
                text += matrix[y][x].description
            }
            text += "\n"
        }
        return text
    }
}

let input = try! String(contentsOfFile: "input.txt", encoding: .utf8)
    .split(separator: "\n")

var grid = Grid()

for line in input {
    let points = line
        .components(separatedBy: " -> ")
        .map { $0.split(separator: ",").compactMap { Int($0) } }
        .map { Point(x: $0[0], y: $0[1]) }

    grid.addLine(from: points[0], to: points[1])
}

print(grid.calculateResult())