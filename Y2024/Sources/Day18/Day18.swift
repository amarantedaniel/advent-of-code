import AdventOfCode
import Collections

enum Constants {
    static let gridSize = 70
    static let bytes = 1_024
}

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

struct State: Hashable, Comparable {
    let distance: Int
    let point: Point

    static func < (lhs: State, rhs: State) -> Bool {
        lhs.distance < rhs.distance
    }

    static func == (lhs: State, rhs: State) -> Bool {
        return lhs.point == rhs.point
    }
}

struct Day18: AdventDay {
    private func parse(input: String) -> [Point] {
        input.split(separator: "\n").map { line in
            let parts = line.split(separator: ",")
            return Point(x: Int(parts[0])!, y: Int(parts[1])!)
        }
    }

    func countSteps(obstacles: [Point]) -> Int? {
        let destination = Point(x: Constants.gridSize, y: Constants.gridSize)
        var distances: [Point: Int] = [.zero: 0]
        var heap = Heap<State>()
        heap.insert(.init(distance: 0, point: .zero))
        while !heap.isEmpty {
            let current = heap.removeMin()
            if current.point == destination {
                return distances[current.point]!
            }
            for neighboor in neighboors(of: current.point, obstacles: obstacles) {
                let distance = distances[current.point]! + 1
                if distance < distances[neighboor, default: Int.max] {
                    distances[neighboor] = distance
                    heap.insert(.init(distance: distance, point: neighboor))
                }
            }
        }

        return distances[destination]
    }

    private func neighboors(of point: Point, obstacles: [Point]) -> [Point] {
        [(-1, 0), (1, 0), (0, 1), (0, -1)]
            .map { y, x in point + Point(x: x, y: y) }
            .filter { !obstacles.contains($0) }
            .filter { $0.x >= 0 && $0.y >= 0 && $0.x <= Constants.gridSize && $0.y <= Constants.gridSize }
    }

    func part1(input: String) throws -> String {
        let obstacles = parse(input: input)
        return "\(countSteps(obstacles: Array(obstacles[0..<Constants.bytes]))!)"
    }

    func part2(input: String) throws -> String {
        let obstacles = parse(input: input)
        var lower = Constants.bytes
        var upper = obstacles.count
        while upper - lower > 1 {
            let i = lower + (upper - lower) / 2
            if countSteps(obstacles: Array(obstacles[0...i])) != nil {
                lower = i
            } else {
                upper = i
            }
        }
        return "\(obstacles[upper].x),\(obstacles[upper].y)"
    }
}
