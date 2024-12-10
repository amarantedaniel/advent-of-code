import AdventOfCode

struct Point: Hashable {
    let i: Int
    let j: Int
}

struct Day10: AdventDay {
    private func parse(input: String) -> [[Int]] {
        input.split(separator: "\n").map { line in
            Array(line).map { character in
                character.wholeNumberValue ?? 99
            }
        }
    }

    private func findReachableEnds(point: Point, grid: [[Int]]) -> Set<Point> {
        if grid[point.i][point.j] == 9 {
            return [point]
        }
        var result: Set<Point> = []
        for neighboor in neighboors(of: point, in: grid) {
            if grid[neighboor.i][neighboor.j] - grid[point.i][point.j] == 1 {
                result.formUnion(findReachableEnds(point: neighboor, grid: grid))
            }
        }
        return result
    }

    private func countPaths(point: Point, grid: [[Int]]) -> Int {
        if grid[point.i][point.j] == 9 {
            return 1
        }
        var result = 0
        for neighboor in neighboors(of: point, in: grid) {
            if grid[neighboor.i][neighboor.j] - grid[point.i][point.j] == 1 {
                result += countPaths(point: neighboor, grid: grid)
            }
        }
        return result
    }

    private func neighboors(of point: Point, in grid: [[Int]]) -> [Point] {
        var result: [Point] = []
        for (di, dj) in [(-1, 0), (1, 0), (0, 1), (0, -1)] {
            let ii = point.i + di
            let jj = point.j + dj
            if ii >= 0 && jj >= 0 && ii < grid.count && jj < grid[ii].count {
                result.append(Point(i: ii, j: jj))
            }
        }
        return result
    }

    private func findTrailHeads(grid: [[Int]]) -> [Point] {
        var result: [Point] = []
        for i in 0..<grid.count {
            for j in 0..<grid[0].count {
                if grid[i][j] == 0 {
                    result.append(Point(i: i, j: j))
                }
            }
        }
        return result
    }

    func part1(input: String) throws -> Int {
        let grid = parse(input: input)
        let trailheads = findTrailHeads(grid: grid)
        return trailheads.reduce(0) { result, trailhead in
            result + findReachableEnds(point: trailhead, grid: grid).count
        }
    }

    func part2(input: String) throws -> Int {
        let grid = parse(input: input)
        let trailheads = findTrailHeads(grid: grid)
        return trailheads.reduce(0) { result, trailhead in
            result + countPaths(point: trailhead, grid: grid)
        }
    }
}
