import AdventOfCode
import Foundation

struct Point: Hashable {
    let x: Int
    let y: Int
}

struct Day15: AdventDay {
    func part1(input: String) -> UInt64 {
        let row = 2000000
        let sensorsAndBeacons = parse(input: input)
        let ranges = getRanges(from: sensorsAndBeacons, row: row)
        let points = Set(sensorsAndBeacons.flatMap { [$0.0, $0.1] })
        var result = 0
        for range in ranges {
            result += range.count - count(points: points, range: range, in: row)
        }
        return UInt64(result)
    }

    func part2(input: String) -> UInt64 {
        let row = 4000000
        let sensorsAndBeacons = parse(input: input)
        for (sensor, beacon) in sensorsAndBeacons {
            let points = getPoints(sensor: sensor, beacon: beacon)
                .filter { $0.x >= 0 && $0.x <= row && $0.y >= 0 && $0.y <= row }
            if let point = findPoint(points: points, in: sensorsAndBeacons) {
                return UInt64(point.y) + (UInt64(point.x) * 4_000_000)
            }
        }
        fatalError()
    }

    private func parse(input: String) -> [(Point, Point)] {
        let pattern = """
        Sensor at x=(-?[0-9]+), y=(-?[0-9]+): closest beacon is at x=(-?[0-9]+), y=(-?[0-9]+)
        """
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(input.startIndex..., in: input)
        let matches = regex.matches(in: input, range: range)
        return matches.map { match in
            let numbers = (1..<match.numberOfRanges).compactMap { index in
                Int(input[Range(match.range(at: index), in: input)!])
            }
            return (Point(x: numbers[0], y: numbers[1]), Point(x: numbers[2], y: numbers[3]))
        }
    }

    private func getRanges(from sensorsAndBeacons: [(Point, Point)], row: Int) -> [ClosedRange<Int>] {
        let ranges = sensorsAndBeacons
            .compactMap { sensor, beacon in
                checkOverlaps(sensor: sensor, beacon: beacon, row: row)
            }.sorted {
                $0.lowerBound < $1.lowerBound
            }
        return join(ranges: ranges)
    }

    private func checkOverlaps(sensor: Point, beacon: Point, row: Int) -> ClosedRange<Int>? {
        let distanceToBeacon = distance(between: sensor, and: beacon)
        let distanceToRow = abs(sensor.y - row)
        if distanceToRow > distanceToBeacon {
            return nil
        }
        let width = 2 * (distanceToBeacon - distanceToRow) + 1
        let range = (sensor.x - width / 2)...(sensor.x + width / 2)
        return range
    }

    private func distance(between lhs: Point, and rhs: Point) -> Int {
        abs(lhs.x - rhs.x) + abs(lhs.y - rhs.y)
    }

    private func join(ranges: [ClosedRange<Int>]) -> [ClosedRange<Int>] {
        var joined: [ClosedRange<Int>] = []
        var open = ranges[0]
        for i in 1..<ranges.count {
            let other = ranges[i]
            if other.lowerBound - open.upperBound <= 1 {
                open = join(lhs: open, rhs: other)
            } else {
                joined.append(open)
                open = other
            }
        }
        joined.append(open)
        return joined
    }

    private func join(lhs: ClosedRange<Int>, rhs: ClosedRange<Int>) -> ClosedRange<Int> {
        let lowerBound = min(lhs.lowerBound, rhs.lowerBound)
        let upperBound = max(lhs.upperBound, rhs.upperBound)
        return lowerBound...upperBound
    }

    private func count(points: Set<Point>, range: ClosedRange<Int>, in row: Int) -> Int {
        points
            .filter { $0.y == row && range.contains($0.x) }
            .count
    }

    private func getPoints(sensor: Point, beacon: Point) -> Set<Point> {
        let distance = distance(between: sensor, and: beacon) + 1
        let edges = [
            Point(x: sensor.x - distance, y: sensor.y),
            Point(x: sensor.x, y: sensor.y - distance),
            Point(x: sensor.x + distance, y: sensor.y),
            Point(x: sensor.x, y: sensor.y + distance),
            Point(x: sensor.x - distance, y: sensor.y)
        ]
        var points: Set<Point> = []
        for i in 0..<edges.count - 1 {
            var current = edges[i]
            let end = edges[i + 1]
            let dx = min(max(end.x - current.x, -1), 1)
            let dy = min(max(end.y - current.y, -1), 1)
            points.insert(current)
            while current != end {
                current = Point(x: current.x + dx, y: current.y + dy)
                points.insert(current)
            }
        }
        return points
    }

    private func findPoint(points: Set<Point>, in sensorsAndBeacons: [(Point, Point)]) -> Point? {
        points.first { point in
            isOutsideAllRanges(point: point, against: sensorsAndBeacons)
        }
    }

    private func isOutsideAllRanges(
        point: Point,
        against sensorsAndBeacons: [(Point, Point)]
    ) -> Bool {
        sensorsAndBeacons.allSatisfy { pair in
            isOutsideRange(sensor: pair.0, beacon: pair.1, point: point)
        }
    }

    private func isOutsideRange(sensor: Point, beacon: Point, point: Point) -> Bool {
        let distanceFromBeacon = distance(between: sensor, and: beacon)
        let distanceFromPoint = distance(between: sensor, and: point)
        return distanceFromPoint > distanceFromBeacon
    }
}
