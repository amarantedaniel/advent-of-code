import AdventOfCode
import Foundation

struct Day08: AdventDay {
    func part1(input: String) -> Int {
        let matrix = parse(input: input)
        var count = 0
        for i in 0..<matrix.count {
            for j in 0..<matrix[i].count where isVisible(i: i, j: j, grid: matrix) {
                count += 1
            }
        }
        return count
    }

    func part2(input: String) -> Int {
        let grid = parse(input: input)
        var score = 0
        for i in 0..<grid.count {
            for j in 0..<grid[i].count {
                let newScore = calculateSeeingScore(i: i, j: j, grid: grid)
                if newScore > score {
                    score = newScore
                }
            }
        }
        return score
    }

    private func parse(input: String) -> [[Int]] {
        input.split(separator: "\n").reduce(into: []) { matrix, line in
            matrix.append(Array(line).compactMap(\.wholeNumberValue))
        }
    }

    private func format(grid: [[Int]]) -> String {
        grid
            .map { $0.map(\.description).joined() }
            .joined(separator: "\n")
    }

    private func isVisible(i: Int, j: Int, grid: [[Int]]) -> Bool {
        if i == 0 || j == 0 || i == grid.count - 1 || j == grid[i].count - 1 {
            return true
        }
        var isVisibleFromRight = true
        var isVisibleFromLeft = true
        var isVisibleFromTop = true
        var isVisibleFromBottom = true
        for ii in i + 1..<grid.count {
            if grid[ii][j] >= grid[i][j] {
                isVisibleFromBottom = false
            }
        }
        for ii in 0..<i {
            if grid[ii][j] >= grid[i][j] {
                isVisibleFromTop = false
            }
        }
        for jj in j + 1..<grid[i].count {
            if grid[i][jj] >= grid[i][j] {
                isVisibleFromLeft = false
            }
        }
        for jj in 0..<j {
            if grid[i][jj] >= grid[i][j] {
                isVisibleFromRight = false
            }
        }
        return isVisibleFromTop || isVisibleFromBottom || isVisibleFromLeft || isVisibleFromRight
    }

    private func calculateSeeingScore(i: Int, j: Int, grid: [[Int]]) -> Int {
        var scoreFromLeft = 0
        var scoreFromRight = 0
        var scoreFromTop = 0
        var scoreFromBottom = 0

        for ii in stride(from: i - 1, to: -1, by: -1) {
            scoreFromTop += 1
            if grid[ii][j] >= grid[i][j] {
                break
            }
        }

        for ii in i + 1..<grid.count {
            scoreFromBottom += 1
            if grid[ii][j] >= grid[i][j] {
                break
            }
        }

        for jj in stride(from: j - 1, to: -1, by: -1) {
            scoreFromLeft += 1
            if grid[i][jj] >= grid[i][j] {
                break
            }
        }

        for jj in j + 1..<grid[i].count {
            scoreFromRight += 1
            if grid[i][jj] >= grid[i][j] {
                break
            }
        }
        return scoreFromTop * scoreFromLeft * scoreFromRight * scoreFromBottom
    }
}
