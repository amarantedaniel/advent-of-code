import Foundation

struct Point {
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

private func distance(between lhs: Point, and rhs: Point) -> Int {
    abs(lhs.x - rhs.x) + abs(lhs.y - rhs.y)
}

func checkOverlaps(sensor: Point, beacon: Point, row: Int) -> ClosedRange<Int>? {
    let distanceToBeacon = distance(between: sensor, and: beacon)
    let distanceToRow = abs(sensor.y - row)
    if distanceToRow > distanceToBeacon {
        return nil
    }
    let width = 2 * (distanceToBeacon - distanceToRow) + 1
    let range = (sensor.x - width / 2)...(sensor.x + width / 2)
    return range
}

func join(lhs: ClosedRange<Int>, rhs: ClosedRange<Int>) -> ClosedRange<Int> {
    let lowerBound = min(lhs.lowerBound, rhs.lowerBound)
    let upperBound = max(lhs.upperBound, rhs.upperBound)
    return lowerBound...upperBound
}

func join(ranges: [ClosedRange<Int>]) -> [ClosedRange<Int>] {
    var joined: [ClosedRange<Int>] = []
    var open = ranges[0]
    for i in 1 ..< ranges.count {
        let other = ranges[i]
        if open.overlaps(other) {
            open = join(lhs: open, rhs: other)
        } else {
            joined.append(open)
            open = other
        }
    }
    joined.append(open)
    return joined
}

private func contains(points: [Point], range: ClosedRange<Int>, in row: Int) -> Bool {
    points.first(where: { $0.y == row && range.contains($0.x) }) != nil
}

func solve1(input: String) -> Int {
    let row = 2000000
    let sensorsAndBeacons = parse(input: input)
    let ranges = sensorsAndBeacons
        .compactMap { sensor, beacon in
            checkOverlaps(sensor: sensor, beacon: beacon, row: row)
        }.sorted {
            $0.lowerBound < $1.lowerBound
        }

    let joined = join(ranges: ranges)
    let sensors = sensorsAndBeacons.map(\.0)
    let beacons = sensorsAndBeacons.map(\.1)

    var count = 0
    for range in joined {
        count += range.count
        if contains(points: sensors, range: range, in: row) {
            count -= 1
        }
        if contains(points: beacons, range: range, in: row) {
            count -= 1
        }
    }
    return count
}

func solve2(input: String) -> Int {
    0
}
