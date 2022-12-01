import Foundation

enum Parser {
    static func parse(input: String, repeating: Int = 1) -> Cave {
        let matrix = input.split(separator: "\n").map {
            expandHorizontally(line: Array($0).compactMap(\.wholeNumberValue),
                               repeating: repeating)
        }
        return expandVertically(matrix: matrix, repeating: repeating)
    }

    private static func expandHorizontally(line: [Int], repeating: Int) -> [Int] {
        var row: [Int] = []
        for i in 0..<repeating {
            let newRow = line.map { increment(value: $0, level: i) }
            row.append(contentsOf: newRow)
        }
        return row
    }

    private static func expandVertically(matrix: [[Int]], repeating: Int) -> [[Int]] {
        var result = matrix
        for i in 1..<repeating {
            for j in 0..<matrix.count {
                let row = matrix[j].map { increment(value: $0, level: i) }
                result.append(row)
            }
        }
        return result
    }

    private static func increment(value: Int, level: Int) -> Int {
        let sum = (value + level)
        if sum > 9 {
            return sum - 9
        }
        return sum
    }
}
