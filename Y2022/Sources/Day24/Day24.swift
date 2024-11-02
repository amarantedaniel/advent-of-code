import AdventOfCode
import Foundation

enum Direction: Character {
    case up = "^"
    case down = "v"
    case left = "<"
    case right = ">"
}

struct Point: Hashable {
    let x: Int
    let y: Int
}

enum Square: Equatable {
    case player
    case wall
    case floor
    case blizzard([Direction])
}

struct Day24: AdventDay {
    func part1(input: String) -> Int {
        let start = Point(x: 1, y: 0)
        var grid = Parser.parse(input: input)
        let finish = Point(x: grid[grid.count - 1].firstIndex(of: .floor)!, y: grid.count - 1)
        return solve(start: start, end: finish, grid: &grid)
    }

    func part2(input: String) -> Int {
        let start = Point(x: 1, y: 0)
        var grid = Parser.parse(input: input)
        let finish = Point(x: grid[grid.count - 1].firstIndex(of: .floor)!, y: grid.count - 1)
        var count = solve(start: start, end: finish, grid: &grid)
        count += solve(start: finish, end: start, grid: &grid)
        count += solve(start: start, end: finish, grid: &grid)
        return count
    }

    private func solve(start: Point, end: Point, grid: inout [[Square]]) -> Int {
        var count = 1
        var players: [Set<Point>] = [[start]]
        while !players.isEmpty {
            grid = moveBlizzards(grid: grid)
            let round = players.removeFirst()
            var nextRound: Set<Point> = []
            for player in round {
                for move in move(player: player, in: grid) {
                    if move == end {
                        return count
                    }
                    nextRound.insert(move)
                }
            }
            players.append(nextRound)
            count += 1
        }
        fatalError()
    }

    func moveBlizzards(grid: [[Square]]) -> [[Square]] {
        var newGrid: [[Square]] = grid
        for y in 1..<grid.count - 1 {
            for x in 1..<grid[y].count - 1 {
                newGrid[y][x] = .floor
            }
        }
        for y in 1..<grid.count - 1 {
            for x in 1..<grid[y].count - 1 {
                guard case let .blizzard(directions) = grid[y][x] else {
                    continue
                }
                let point = Point(x: x, y: y)
                for direction in directions {
                    let destination = apply(direction: direction, to: point, clampedIn: grid)
                    if case let .blizzard(directions2) = newGrid[destination.y][destination.x] {
                        newGrid[destination.y][destination.x] = .blizzard(directions2 + [direction])
                    } else {
                        newGrid[destination.y][destination.x] = .blizzard([direction])
                    }
                }
            }
        }
        return newGrid
    }

    func apply(direction: Direction, to point: Point, clampedIn grid: [[Square]]) -> Point {
        switch direction {
        case .left:
            return Point(x: point.x - 1 == 0 ? grid[point.y].count - 2 : point.x - 1, y: point.y)
        case .right:
            return Point(x: max(1, (point.x + 1) % (grid[point.y].count - 1)), y: point.y)
        case .up:
            return Point(x: point.x, y: point.y - 1 == 0 ? grid.count - 2 : point.y - 1)
        case .down:
            return Point(x: point.x, y: max(1, (point.y + 1) % (grid.count - 1)))
        }
    }

    func move(player: Point, in grid: [[Square]]) -> [Point] {
        var result: [Point] = []
        for (x, y) in [(0, 0), (1, 0), (-1, 0), (0, 1), (0, -1)] {
            let attempt = Point(x: player.x + x, y: player.y + y)
            guard attempt.y >= 0, attempt.x >= 0, attempt.y < grid.count, attempt.x < grid[attempt.y].count else {
                continue
            }
            if case .floor = grid[attempt.y][attempt.x] {
                result.append(attempt)
            }
        }
        return result
    }
}
