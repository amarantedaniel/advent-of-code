import AdventOfCode
import Foundation

struct Point: Equatable, Hashable {
    let x: Int
    let y: Int
}

struct Day14: AdventDay {
    func part1(input: String) -> Int {
        var (points, floor) = parse(input: input)
        var i = 0
        while true {
            let point = fall(points: points, point: Point(x: 500, y: 0), floor: floor)
            if point.y == floor - 1 {
                return i
            }
            points.insert(point)
            i += 1
        }
    }

    func part2(input: String) -> Int {
        var (points, floor) = parse(input: input)
        var i = 0
        while true {
            let point = fall(points: points, point: Point(x: 500, y: 0), floor: floor)
            points.insert(point)
            i += 1
            if point == Point(x: 500, y: 0) {
                return i
            }
        }
    }

    private func parse(input: String) -> (Set<Point>, Int) {
        let lines = input.split(separator: "\n")
            .map { line in
                String(line).components(separatedBy: " -> ").map { point in
                    let xy = point.split(separator: ",").compactMap { Int($0) }
                    return Point(x: xy[0], y: xy[1])
                }
            }
        var points: Set<Point> = []
        let maxY = lines.flatMap { $0 }.map(\.y).max()!

        for line in lines {
            for i in 0..<line.count - 1 {
                var current = line[i]
                let end = line[i + 1]
                let dx = min(max(end.x - current.x, -1), 1)
                let dy = min(max(end.y - current.y, -1), 1)
                points.insert(current)
                while current != end {
                    current = Point(x: current.x + dx, y: current.y + dy)
                    points.insert(current)
                }
            }
        }
        return (points, maxY + 2)
    }

    private func fall(points: Set<Point>, point: Point, floor: Int) -> Point {
        for direction in [(0, 1), (-1, 1), (1, 1)] {
            let newPoint = Point(x: point.x + direction.0, y: point.y + direction.1)
            if !points.contains(newPoint), newPoint.y < floor {
                return fall(points: points, point: newPoint, floor: floor)
            }
        }
        return point
    }
}
