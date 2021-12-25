import CloudKit
import Foundation

extension String {
    func slice(from: String, to: String) -> Substring? {
        guard let fromIndex = range(of: from)?.upperBound else { return nil }
        guard let toIndex = range(of: to, range: fromIndex..<endIndex)?.lowerBound else { return nil }
        return self[fromIndex..<toIndex]
    }
}

enum Parser {
    static func parse(input: String) -> Rect {
        let xValues = input.slice(from: "x=", to: ",")!.components(separatedBy: "..").compactMap { Int($0) }
        let yValues = input.slice(from: "y=", to: "\n")!.components(separatedBy: "..").compactMap { Int($0) }
        let origin = Point(x: xValues.min()!, y: yValues.max()!)
        let size = Size(width: abs(xValues[0] - xValues[1]), height: abs(yValues[0] - yValues[1]))
        return Rect(origin: origin, size: size)
    }
}

extension Array where Element == Point {
    var maxY: Int {
        self.max(by: { $0.y < $1.y })!.y
    }
}

struct Velocity {
    var x: Int
    var y: Int

    mutating func degrade() {
        y -= 1
        if x > 0 { x -= 1 }
        if x < 0 { x += 1 }
    }
}

struct Point: Hashable {
    var x: Int
    var y: Int

    static let zero = Point(x: 0, y: 0)

    func isInside(rect: Rect) -> Bool {
        x >= rect.origin.x && y <= rect.origin.y && x <= rect.maxX && y >= rect.minY
    }

    func isAfter(rect: Rect) -> Bool {
        x > rect.maxX || y < rect.minY
    }

    mutating func apply(velocity: Velocity) {
        x += velocity.x
        y += velocity.y
    }
}

struct Size {
    let width: Int
    let height: Int
}

struct Rect {
    let origin: Point
    let size: Size

    var maxX: Int { origin.x + size.width }
    var minY: Int { origin.y - size.height }
}

func draw(rect: Rect, trajectory: [Point]) -> String {
    let points = Set(trajectory)
    let top = max(max(0, rect.origin.y), trajectory.maxY)
    let bottom = min(0, rect.minY)
    var result = ""
    for y in stride(from: top, to: bottom - 1, by: -1) {
        for x in 0 ... rect.maxX {
            let point = Point(x: x, y: y)
            if point == .zero {
                result += "S"
            } else if points.contains(point) {
                result += "#"
            } else if point.isInside(rect: rect) {
                result += "T"
            } else {
                result += "."
            }
        }
        result += "\n"
    }
    return result
}

func calculateTrajectory(velocity: Velocity, to rect: Rect) -> (Bool, [Point]) {
    var points: [Point] = []
    var velocity = velocity
    var point = Point.zero
    while !point.isAfter(rect: rect) {
        point.apply(velocity: velocity)
        velocity.degrade()
        points.append(point)
        if point.isInside(rect: rect) {
            return (true, points)
        }
    }
    return (false, points)
}

func solve1(input: String) -> Int {
    let arbitraryMaxValue = 200
    let rect = Parser.parse(input: input)
    var maxHeight = 0
    for x in 0 ... rect.maxX {
        for y in 0..<arbitraryMaxValue {
            let (didHit, trajectory) = calculateTrajectory(velocity: Velocity(x: x, y: y), to: rect)
            if didHit {
                let height = trajectory.max { $0.y < $1.y }!.y
                if height > maxHeight {
                    maxHeight = height
                }
            }
        }
    }

    return maxHeight
}

func solve2(input: String) -> Int {
    let arbitraryMaxValue = 200
    let rect = Parser.parse(input: input)
    var count = 0
    for x in 0 ... rect.maxX {
        for y in rect.minY..<arbitraryMaxValue {
            let (didHit, _) = calculateTrajectory(velocity: Velocity(x: x, y: y), to: rect)
            if didHit {
                count += 1
            }
        }
    }
    return count
}
