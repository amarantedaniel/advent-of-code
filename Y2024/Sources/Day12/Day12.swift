import AdventOfCode

struct Point: Hashable {
    let x: Int
    let y: Int
}

struct Result {
    var area = 0
    var perimeter = 0
    var corners = 0
    var seen: Set<Point> = []
}

struct Day12: AdventDay {
    private func parse(input: String) -> [[Character]] {
        input.split(separator: "\n").map {
            Array($0)
        }
    }

    private func calculate(grid: [[Character]], start: Point) -> Result? {
        var remaining: Set<Point> = [start]
        let character = grid[start.x][start.y]
        var result = Result()

        while !remaining.isEmpty {
            let current = remaining.removeFirst()
            result.area += 1
            result.seen.insert(current)
            let neighboors = neighboors(
                point: current, character: character, grid: grid
            )
            result.perimeter += 4 - neighboors.count
            remaining.formUnion(
                neighboors.filter { !result.seen.contains($0) }
            )
        }
        for point in result.seen {
            result.corners += countCorners(point: point, points: result.seen)
        }
        return result
    }

    private func neighboors(
        point: Point, character: Character, grid: [[Character]]
    ) -> [Point] {
        var neighboors: [Point] = []
        for (dx, dy) in [(-1, 0), (1, 0), (0, 1), (0, -1)] {
            let neighboor = Point(x: point.x + dx, y: point.y + dy)
            guard isInside(grid: grid, point: neighboor) else {
                continue
            }
            guard grid[neighboor.x][neighboor.y] == character else {
                continue
            }
            neighboors.append(neighboor)
        }
        return neighboors
    }

    private func isInside(grid: [[Character]], point: Point) -> Bool {
        point.x >= 0 && point.y >= 0 && point.x < grid.count && point.y < grid[point.x].count
    }

    private func countCorners(point: Point, points: Set<Point>) -> Int {
        let corners = [
            (Point(x: -1, y: 0), Point(x: -1, y: -1), Point(x: 0, y: -1)),
            (Point(x: -1, y: 0), Point(x: -1, y: 1), Point(x: 0, y: 1)),
            (Point(x: 1, y: 0), Point(x: 1, y: -1), Point(x: 0, y: -1)),
            (Point(x: 1, y: 0), Point(x: 1, y: 1), Point(x: 0, y: 1)),
        ]
        var result = 0
        for (dp1, dp2, dp3) in corners {
            let p1 = Point(x: dp1.x + point.x, y: dp1.y + point.y)
            let p2 = Point(x: dp2.x + point.x, y: dp2.y + point.y)
            let p3 = Point(x: dp3.x + point.x, y: dp3.y + point.y)
            if !points.contains(p1) && !points.contains(p3) {
                result += 1
            }
            if points.contains(p1) && !points.contains(p2) && points.contains(p3) {
                result += 1
            }
        }
        return result
    }

    private func solve(grid: [[Character]], calculation: (Result) -> Int) -> Int {
        var seen: Set<Point> = []
        var count = 0
        for x in 0..<grid.count {
            for y in 0..<grid[x].count {
                let point = Point(x: x, y: y)
                if seen.contains(point) {
                    continue
                }
                if let result = calculate(grid: grid, start: Point(x: x, y: y)) {
                    seen.formUnion(result.seen)
                    count += calculation(result)
                }
            }
        }
        return count
    }

    func part1(input: String) throws -> Int {
        let grid = parse(input: input)
        return solve(grid: grid, calculation: { $0.area * $0.perimeter })
    }

    func part2(input: String) throws -> Int {
        let grid = parse(input: input)
        return solve(grid: grid, calculation: { $0.area * $0.corners })
    }
}
