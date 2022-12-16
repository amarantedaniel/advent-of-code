import Foundation

struct Point: Hashable {
    let x: Int
    let y: Int
}

private func parse(input: String) -> [(Point, Point)] {
    let pattern = """
    Sensor at x=(-?[0-9]+), y=(-?[0-9]+): closest beacon is at x=(-?[0-9]+), y=(-?[0-9]+)
    """
    let regex = try! NSRegularExpression(pattern: pattern)
    let range = NSRange(input.startIndex..., in: input)
    let matches = regex.matches(in: input, range: range)
    return matches.map { match in
        let numbers = (1 ..< match.numberOfRanges).compactMap { index in
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
    for i in 1 ..< ranges.count {
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

func solve1(input: String, row: Int) -> Int {
    let sensorsAndBeacons = parse(input: input)
    let ranges = getRanges(from: sensorsAndBeacons, row: row)
    let points = Set(sensorsAndBeacons.flatMap { [$0.0, $0.1] })
    var result = 0
    for range in ranges {
        result += range.count - count(points: points, range: range, in: row)
    }
    return result
}

func solve2(input: String, row: Int) -> UInt64 {
    let sensorsAndBeacons = parse(input: input)
    for y in 0...row {
        let ranges = getRanges(from: sensorsAndBeacons, row: y)
        if ranges.count > 1 {
            let x = ranges[0].upperBound + 1
            return UInt64(y) + (UInt64(x) * 4000000)
        }
    }
    fatalError()
}
