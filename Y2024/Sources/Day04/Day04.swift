import AdventOfCode
enum Letter: Character {
    case x = "X"
    case m = "M"
    case a = "A"
    case s = "S"
}

struct Day04: AdventDay {
    private func parse(input: String) -> [[Letter]] {
        var result: [[Letter]] = []
        for line in input.split(separator: "\n") {
            result.append(
                Array(line).compactMap(Letter.init(rawValue:))
            )
        }
        return result
    }

    private func countWords(grid: [[Letter]], i: Int, j: Int) -> Int {
        var count = 0
        let directions = [
            (-1, 0), (1, 0), (0, -1), (0, 1),
            (-1, -1), (-1, 1), (1, -1), (1, 1)
        ]
        for (ii, jj) in directions {
            var word: [Letter] = []
            for z in 0..<4 {
                let iii = i + ii * z
                let jjj = j + jj * z
                guard isInside(grid: grid, i: iii, j: jjj) else {
                    break
                }
                word.append(grid[iii][jjj])
            }
            if word == [.x, .m, .a, .s] {
                count += 1
            }
        }
        return count
    }

    private func hasWordAcross(grid: [[Letter]], i: Int, j: Int) -> Bool {
        let diagonals = [
            [(-1, -1), (1, 1)],
            [(1, 1), (-1, -1)],
            [(1, -1), (-1, 1)],
            [(-1, 1), (1, -1)],
        ]
        var count = 0
        for diagonal in diagonals {
            var word: [Letter] = []
            for (ii, jj) in diagonal {
                let iii = i + ii
                let jjj = j + jj
                guard isInside(grid: grid, i: iii, j: jjj) else {
                    return false
                }
                word.append(grid[iii][jjj])
            }
            if word == [.m, .s] {
                count += 1
            }
        }
        return count == 2
    }

    private func isInside(grid: [[Letter]], i: Int, j: Int) -> Bool {
        i >= 0 && j >= 0 && i < grid.count && j < grid[i].count
    }

    func part1(input: String) throws -> Int {
        let grid = parse(input: input)
        var result = 0
        for i in 0..<grid.count {
            for j in 0..<grid[i].count where grid[i][j] == .x {
                result += countWords(grid: grid, i: i, j: j)
            }
        }
        return result
    }

    func part2(input: String) throws -> Int {
        let grid = parse(input: input)
        var result = 0
        for i in 0..<grid.count {
            for j in 0..<grid[i].count where grid[i][j] == .a {
                result += hasWordAcross(grid: grid, i: i, j: j) ? 1 : 0
            }
        }
        return result
    }
}
