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

enum Direction: CaseIterable {
    case up
    case down
    case left
    case right

    func vector() -> Point {
        switch self {
        case .up:
            return Point(x: 0, y: -1)
        case .down:
            return Point(x: 0, y: 1)
        case .left:
            return Point(x: -1, y: 0)
        case .right:
            return Point(x: 1, y: 0)
        }
    }
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

struct State: Hashable, Comparable {
    let distance: Int
    let direction: Direction
    let point: Point

    static func < (lhs: State, rhs: State) -> Bool {
        lhs.distance < rhs.distance
    }

    static func == (lhs: State, rhs: State) -> Bool {
        return lhs.point == rhs.point && lhs.direction == rhs.direction
    }
}

struct Day16: AdventDay {
    func dijkstra(map: [[Square]], source: Point, destination: Point) -> Int {
        var distances: [Point: Int] = [source: 0]
        var previous: [Point: Point] = [:]
        var heap = Heap<State>()
        heap.insert(.init(distance: 0, direction: .right, point: source))
        while !heap.isEmpty {
            let current = heap.removeMin()
            if current.point == destination {
                return distances[current.point]!
            }
            for (direction, neighboor) in neighboors(for: current.point, in: map) {
                let distance = distances[current.point]! + 1 + (direction == current.direction ? 0 : 1_000)
                if distance < distances[neighboor, default: Int.max] {
                    distances[neighboor] = distance
                    previous[neighboor] = current.point
                    heap.insert(.init(distance: distance, direction: direction, point: neighboor))
                }
            }
        }
        fatalError()
    }
    
    func allBestPaths(
        map: [[Square]],
        bestScore: Int,
        state: State,
        destination: Point,
        visited: Set<Point>
    ) -> Set<Point> {
        if state.distance > bestScore {
            return []
        }
        if state.point == destination && state.distance == bestScore {
            return visited
        }
        var count: Set<Point> = []
        for (direction, neighboor) in neighboors(for: state.point, in: map) where !visited.contains(neighboor) {
            let distance = state.distance + 1 + (direction == state.direction ? 0 : 1_000)
            count.formUnion(
                allBestPaths(
                    map: map,
                    bestScore: bestScore,
                    state: State(distance: distance, direction: direction, point: neighboor),
                    destination: destination,
                    visited: visited.union([neighboor])
                )
            )
        }
        return count
    }

    private func neighboors(for point: Point, in map: [[Square]]) -> [(Direction, Point)] {
        var result: [(Direction, Point)] = []
        for direction in Direction.allCases {
            let vector = direction.vector()
            let neighboor = point + vector
            if map[neighboor.y][neighboor.x] == .path {
                result.append((direction, neighboor))
            }
        }
        return result
    }

    func part1(input: String) throws -> Int {
        let (start, end, map) = Parser.parse(input: input)
        return dijkstra(map: map, source: start, destination: end)
    }

    func part2(input: String) throws -> Int {
        let (start, end, map) = Parser.parse(input: input)
        return allBestPaths(
            map: map,
            bestScore: dijkstra(map: map, source: start, destination: end),
            state: .init(distance: 0, direction: .right, point: start),
            destination: end,
            visited: [start]
        ).count
    }
}
