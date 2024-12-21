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

enum Direction: String, CaseIterable {
    case up = "^"
    case down = "v"
    case left = "<"
    case right = ">"

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

    func inverse() -> Direction {
        switch self {
        case .up:
            return .down
        case .down:
            return .up
        case .left:
            return .right
        case .right:
            return .left
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

struct PointAndDirection: Hashable {
    let point: Point
    let direction: Direction
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
    func dijkstra(
        map: [[Square]],
        source: Point,
        startDirection: Direction,
        destination: Point,
        backwards: Bool
    ) -> [PointAndDirection: Int] {
        var distances: [PointAndDirection: Int] = [.init(point: source, direction: startDirection): 0]
        var heap = Heap<State>()
        heap.insert(.init(distance: 0, direction: startDirection, point: source))
        while !heap.isEmpty {
            let current = heap.removeMin()

            if let next = moveForward(from: current.point, direction: backwards ? current.direction.inverse() : current.direction, in: map) {
                let distance = distances[.init(point: current.point, direction: current.direction)]! + 1
                if distance < distances[.init(point: next, direction: current.direction), default: Int.max] {
                    distances[.init(point: next, direction: current.direction)] = distance
                    heap.insert(.init(distance: distance, direction: current.direction, point: next))
                }
            }

            for direction in Direction.allCases {
                let distance = distances[.init(point: current.point, direction: current.direction)]! + 1_000
                if distance < distances[.init(point: current.point, direction: direction), default: Int.max] {
                    distances[.init(point: current.point, direction: direction)] = distance
                    heap.insert(.init(distance: distance, direction: direction, point: current.point))
                }
            }
        }
        return distances
    }

    private func moveForward(from point: Point, direction: Direction, in map: [[Square]]) -> Point? {
        let next = point + direction.vector()
        if map[next.y][next.x] == .path {
            return next
        }
        return nil
    }

    func part1(input: String) throws -> Int {
        let (start, end, map) = Parser.parse(input: input)
        let distances = dijkstra(map: map, source: start, startDirection: .right, destination: end, backwards: false)
        return Direction.allCases
            .compactMap { distances[.init(point: end, direction: $0)] }
            .min()!
    }

    func part2(input: String) throws -> Int {
        let (start, end, map) = Parser.parse(input: input)
        let distancesFromStart = dijkstra(map: map, source: start, startDirection: .right, destination: end, backwards: false)

        let goalDistance = Direction.allCases
            .compactMap { distancesFromStart[.init(point: end, direction: $0)] }
            .min()!

        let distancesFromEnd = Dictionary(uniqueKeysWithValues: Direction.allCases.map { direction in
            (direction, dijkstra(map: map, source: end, startDirection: direction, destination: start, backwards: true))
        })

        var points: Set<Point> = []
        for (pointAndDirection, distanceFromStart) in distancesFromStart {
            for direction in Direction.allCases {
                if let distanceFromEnd = distancesFromEnd[direction]![pointAndDirection] {
                    if distanceFromStart + distanceFromEnd == goalDistance {
                        points.insert(pointAndDirection.point)
                    }
                }
            }
        }
        return points.count
    }
}
