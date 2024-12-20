import AdventOfCode
import Collections

struct Point: Equatable, Hashable, AdditiveArithmetic {
    static let zero = Point(x: 0, y: 0)
    let x: Int
    let y: Int

    static func - (lhs: Point, rhs: Point) -> Point {
        Point(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    static func + (lhs: Point, rhs: Point) -> Point {
        Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}

enum Square: Character {
    case wall = "#"
    case path = "."
}

enum Parser {
    static func parse(input: String) -> (Point, Point, [[Square]]) {
        var start: Point!
        var end: Point!
        var map: [[Square]] = []
        for (y, line) in input.split(separator: "\n").enumerated() {
            var row: [Square] = []
            for (x, character) in line.enumerated() {
                switch character {
                case "S":
                    start = Point(x: x, y: y)
                    row.append(.path)
                case "E":
                    end = Point(x: x, y: y)
                    row.append(.path)
                default:
                    row.append(Square(rawValue: character)!)
                }
            }
            map.append(row)
        }
        return (start, end, map)
    }
}

struct Day20: AdventDay {
    private func findPath(from origin: Point, to destination: Point, in map: [[Square]]) -> [Point: Int] {
        var visited: Set<Point> = [origin]
        var distances: [Point: Int] = [origin: 0]
        var distance = 1
        var current = origin
        while current != destination {
            current = next(from: current, in: map, visited: visited)
            visited.insert(current)
            distances[current] = distance
            distance += 1
        }
        return distances
    }

    private func next(from point: Point, in map: [[Square]], visited: Set<Point>) -> Point {
        for (dy, dx) in [(-1, 0), (1, 0), (0, -1), (0, 1)] {
            let neighboor = point + Point(x: dx, y: dy)
            if map[neighboor.y][neighboor.x] == .path, !visited.contains(neighboor) {
                return neighboor
            }
        }
        fatalError()
    }

    private func findCheats(
        from origin: Point,
        to destination: Point,
        in map: [[Square]],
        distances: [Point: Int],
        cheatTime: Int
    ) -> Int {
        var visited: Set<Point> = [origin]
        var current = origin
        var result = 0
        while current != destination {
            result += findCheat(
                from: current,
                in: map,
                distances: distances,
                cheatTime: cheatTime
            )
            current = next(from: current, in: map, visited: visited)
            visited.insert(current)
        }
        return result
    }

    private func findCheat(
        from point: Point,
        in map: [[Square]],
        distances: [Point: Int],
        cheatTime: Int
    ) -> Int {
        var result = 0
        for dy in -cheatTime...cheatTime {
            for dx in -cheatTime...cheatTime {
                guard abs(dx) + abs(dy) <= cheatTime else { continue }
                let destination = point + Point(x: dx, y: dy)
                guard
                    destination.x > 0,
                    destination.y > 0,
                    destination.y < map.count - 1,
                    destination.x < map[destination.y].count - 1,
                    map[destination.y][destination.x] == .path,
                    distances[destination]! > distances[point]!
                else {
                    continue
                }
                let cheatDistance = abs(destination.y - point.y) + abs(destination.x - point.x)
                let totalDistance = distances[destination]! - distances[point]! - cheatDistance
                if totalDistance >= 100 {
                    result += 1
                }
            }
        }
        return result
    }

    func part1(input: String) throws -> Int {
        let (start, end, map) = Parser.parse(input: input)
        let distances = findPath(from: start, to: end, in: map)
        return findCheats(from: start, to: end, in: map, distances: distances, cheatTime: 2)
    }

    func part2(input: String) throws -> Int {
        let (start, end, map) = Parser.parse(input: input)
        let distances = findPath(from: start, to: end, in: map)
        return findCheats(from: start, to: end, in: map, distances: distances, cheatTime: 20)
    }
}
