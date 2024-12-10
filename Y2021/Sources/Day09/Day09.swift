import AdventOfCode
import Foundation

struct Point: Hashable {
    let i: Int
    let j: Int

    func hash(into hasher: inout Hasher) {
        i.hash(into: &hasher)
        j.hash(into: &hasher)
    }
}

extension Array where Element == [Int] {
    func forEach(_ block: (Int, Int) -> Void) {
        for i in 0..<count {
            for j in 0..<self[i].count {
                block(i, j)
            }
        }
    }

    func forEachAdjacent(i: Int, j: Int, _ block: (Int, Int) -> Void) {
        for ii in Swift.max(i - 1, 0)...Swift.min(i + 1, self.count - 1) {
            for jj in Swift.max(j - 1, 0)...Swift.min(j + 1, self[i].count - 1) where (i == ii || j == jj) && !(i == ii && j == jj) {
                block(ii, jj)
            }
        }
    }

    func formatted(only: Set<Point>? = nil) -> String {
        var currentLine = 0
        var text = ""
        forEach { i, j in
            if i > currentLine {
                text += "\n"
                currentLine = i
            }
            if let only = only, !only.contains(Point(i: i, j: j)) {
                text += "x"
            } else {
                text += self[i][j].description
            }
        }
        return text
    }
}

struct Day09: AdventDay {
    func isLowest(matrix: [[Int]], i: Int, j: Int, excluding excluded: Int = -1) -> Bool {
        guard matrix[i][j] > excluded, matrix[i][j] < 9 else { return false }
        var isLowest = true
        matrix.forEachAdjacent(i: i, j: j) { ii, jj in
            if matrix[ii][jj] < matrix[i][j], matrix[ii][jj] > excluded {
                isLowest = false
            }
        }
        return isLowest
    }

    func findLowestPoints(in matrix: [[Int]]) -> [Point] {
        var lowestPoints: [Point] = []
        matrix.forEach { i, j in
            if isLowest(matrix: matrix, i: i, j: j) {
                lowestPoints.append(Point(i: i, j: j))
            }
        }
        return lowestPoints
    }

    func findBasin(in matrix: [[Int]], i: Int, j: Int) -> Set<Point> {
        var numbers: Set<Point> = [Point(i: i, j: j)]
        matrix.forEachAdjacent(i: i, j: j) { ii, jj in
            if isLowest(matrix: matrix, i: ii, j: jj, excluding: matrix[i][j]) {
                numbers.formUnion(findBasin(in: matrix, i: ii, j: jj))
            }
        }
        return numbers
    }

    func part1(input: String) throws -> Int {
        throw AdventError.notImplemented
    }

    func part2(input: String) -> Int {
        let matrix = input
            .split(separator: "\n")
            .reduce(into: []) { matrix, row in
                matrix.append(Array(row).compactMap(\.wholeNumberValue))
            }
        let lowestPoints = findLowestPoints(in: matrix)

        var basins: [Set<Point>] = []
        for point in lowestPoints {
            let basin = findBasin(in: matrix, i: point.i, j: point.j)
            basins.append(basin)
        }
        return basins.map(\.count).sorted().suffix(3).reduce(1, *)
    }
}
