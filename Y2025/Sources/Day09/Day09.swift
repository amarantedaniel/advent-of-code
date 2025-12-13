import AdventOfCode

struct Point: Equatable, Hashable { let x, y: Int }

struct Day09: AdventDay {
    private func parse(input: String) -> [Point] {
        input.split(separator: "\n")
            .map { $0.split(separator: ",") }
            .map { Point(x: Int($0[0])!, y: Int($0[1])!) }
    }

    func part1(input: String) throws -> Int {
        let points = parse(input: input)
        var result = 0
        for p1 in points {
            for p2 in points where p1 != p2 {
                result = max(area(p1: p1, p2: p2), result)
            }
        }
        return result
    }

    func part2(input: String) throws -> Int {
        let (corners, mapping) = minimize(points: parse(input: input))
        let shape = fillWalls(points: corners)
        let flood = fillInsides(points: shape)
        var result = 0
        for p1 in corners {
            for p2 in corners where p1 != p2 {
                if isInside(p1: p1, p2: p2, points: flood) {
                    let area = area(p1: p1, p2: p2, mapping: mapping)
                    result = max(area, result)
                }
            }
        }
        return result
    }

    private func isInside(p1: Point, p2: Point, points: Set<Point>) -> Bool {
        for y in min(p1.y, p2.y)..<max(p1.y, p2.y) {
            let pp1 = Point(x: p1.x, y: y)
            let pp2 = Point(x: p2.x, y: y)
            guard points.isSuperset(of: [pp1, pp2]) else {
                return false
            }
        }
        for x in min(p1.x, p2.x)..<max(p1.x, p2.x) {
            let pp1 = Point(x: x, y: p1.y)
            let pp2 = Point(x: x, y: p2.y)
            guard points.isSuperset(of: [pp1, pp2]) else {
                return false
            }
        }
        return true
    }

    private func fillWalls(points: [Point]) -> [Point] {
        var result: [Point] = []
        for i in 0..<points.count {
            let p1 = points[i]
            let p2 = points[(i + 1) % points.count]
            result.append(p1)
            if p1.y == p2.y {
                for x in (min(p1.x, p2.x) + 1)..<max(p1.x, p2.x) {
                    result.append(Point(x: x, y: p1.y))
                }
            } else {
                for y in (min(p1.y, p2.y) + 1)...max(p1.y, p2.y) {
                    result.append(Point(x: p1.x, y: y))
                }
            }
            result.append(p2)
        }
        return result
    }

    private func fillInsides(points: [Point]) -> Set<Point> {
        var result: Set<Point> = Set(points)
        var remaining: Set<Point> = [findStartingPoint(points: result)]
        let directions = [
            (-1, 0), (1, 0), (0, -1), (0, 1),
            (-1, -1), (-1, 1), (1, -1), (1, 1)
        ]
        while !remaining.isEmpty {
            let point = remaining.removeFirst()
            result.insert(point)
            for direction in directions {
                let next = Point(x: point.x + direction.0, y: point.y + direction.1)
                if !result.contains(next) && !remaining.contains(next) {
                    remaining.insert(
                        Point(x: point.x + direction.0, y: point.y + direction.1)
                    )
                }
            }
        }
        return result
    }

    private func findStartingPoint(points: Set<Point>) -> Point {
        var x = points.map(\.x).min()!
        var y = points.map(\.y).min()!
        while true {
            if points.contains(Point(x: x, y: y)) {
                return Point(x: x + 1, y: y + 1)
            }
            x += 1
            y += 1
        }
    }

    private func minimize(points: [Point]) -> ([Point], [Int: Int]) {
        var largeToSmall: [Int: Int] = [:]
        var smallToLarge: [Int: Int] = [:]
        let coordinates = Set(points.map(\.x) + points.map(\.y)).sorted()
        for (i, coordinate) in coordinates.enumerated() {
            largeToSmall[coordinate] = i + 1
            smallToLarge[i + 1] = coordinate
        }
        let smallPoints = points.map {
            Point(x: largeToSmall[$0.x]!, y: largeToSmall[$0.y]!)
        }
        return (smallPoints, smallToLarge)
    }

    private func area(p1: Point, p2: Point) -> Int {
        let sidex = abs(p1.x - p2.x) + 1
        let sidey = abs(p1.y - p2.y) + 1
        return sidex * sidey
    }

    private func area(p1: Point, p2: Point, mapping: [Int: Int]) -> Int {
        let sidex = abs(mapping[p1.x]! - mapping[p2.x]!) + 1
        let sidey = abs(mapping[p1.y]! - mapping[p2.y]!) + 1
        return sidex * sidey
    }
}
