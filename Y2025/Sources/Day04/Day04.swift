import AdventOfCode

struct Coordinate: Hashable { let i, j: Int }

struct Day04: AdventDay {

    private func parse(input: String) -> [[Bool]] {
        input.split(separator: "\n").map { line in
            Array(line).map { $0 == "@" }
        }
    }

    func part1(input: String) throws -> Int {
        let grid = parse(input: input)
        return checkItemsToRemove(from: grid).count
    }

    func part2(input: String) throws -> Int {
        var grid = parse(input: input)
        var result = 0
        var items = checkItemsToRemove(from: grid)
        while items.count > 0 {
            result += items.count
            remove(items: items, from: &grid)
            items = checkItemsToRemove(from: grid)
        }
        return result
    }

    private func remove(items: Set<Coordinate>, from grid: inout [[Bool]]) {
        for i in 0 ..< grid.count {
            for j in 0 ..< grid[i].count {
                if items.contains(.init(i: i, j: j)) {
                    grid[i][j] = false
                }
            }
        }
    }

    private func checkItemsToRemove(from grid: [[Bool]]) -> Set<Coordinate> {
        var canRemove: Set<Coordinate> = []
        let directions = [
            (-1, 0), (1, 0), (0, -1), (0, 1),
            (-1, -1), (-1, 1), (1, -1), (1, 1)
        ]
        for i in 0 ..< grid.count {
            for j in 0 ..< grid[i].count where grid[i][j] {
                var count = 0
                for (di, dj) in directions {
                    let ii = i + di
                    let jj = j + dj
                    guard ii >= 0, ii < grid.count else { continue }
                    guard jj >= 0, jj < grid[ii].count else { continue }
                    if grid[ii][jj] {
                        count += 1
                    }
                }
                if count < 4 {
                    canRemove.insert(.init(i: i, j: j))
                }
            }
        }

        return canRemove
    }
}
