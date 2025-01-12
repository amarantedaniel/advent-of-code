import AdventOfCode

enum ArrowKey: Hashable {
    case direction(Direction)
    case submit
}

struct Cache: Hashable {
    let keys: [ArrowKey]
    let depth: Int
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

enum Numpad {
    static let positions: [Character: Point] = [
        "7": Point(x: 0, y: 0), "8": Point(x: 1, y: 0), "9": Point(x: 2, y: 0),
        "4": Point(x: 0, y: 1), "5": Point(x: 1, y: 1), "6": Point(x: 2, y: 1),
        "1": Point(x: 0, y: 2), "2": Point(x: 1, y: 2), "3": Point(x: 2, y: 2),
        "0": Point(x: 1, y: 3), "A": Point(x: 2, y: 3),
    ]
}

struct ArrowPad: Hashable {
    static let positions: [ArrowKey: Point] = [
        .direction(.up): Point(x: 1, y: 0), .submit: Point(x: 2, y: 0),
        .direction(.left): Point(x: 0, y: 1), .direction(.down): Point(x: 1, y: 1), .direction(.right): Point(x: 2, y: 1),
    ]
}

enum Direction: String {
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
}

struct Day21: AdventDay {
    private func move(from p1: Point, to p2: Point, forbidden: Point) -> [[Direction]] {
        if p1 == p2 {
            return [[]]
        }

        if p1.x == p2.x {
            return [Array(repeating: p2.y > p1.y ? .down : .up, count: abs(p2.y - p1.y))]
        }

        if p1.y == p2.y {
            return [Array(repeating: p2.x > p1.x ? .right : .left, count: abs(p2.x - p1.x))]
        }

        return [
            Array(repeating: p2.y > p1.y ? .down : .up, count: abs(p2.y - p1.y)) + Array(repeating: p2.x > p1.x ? .right : .left, count: abs(p2.x - p1.x)),
            Array(repeating: p2.x > p1.x ? .right : .left, count: abs(p2.x - p1.x)) + Array(repeating: p2.y > p1.y ? .down : .up, count: abs(p2.y - p1.y))
        ].filter { directions in !contains(directions: directions, from: p1, forbidden: forbidden) }
    }

    private func contains(directions: [Direction], from point: Point, forbidden: Point) -> Bool {
        var point = point
        for direction in directions {
            point = point + direction.vector()
            if point == forbidden {
                return true
            }
        }
        return false
    }

    func move(from origin: Character, to destination: Character) -> [[ArrowKey]] {
        let p1 = Numpad.positions[origin]!
        let p2 = Numpad.positions[destination]!
        return move(from: p1, to: p2, forbidden: Point(x: 0, y: 3)).map { $0.map { ArrowKey.direction($0) } }
    }

    func move(from origin: ArrowKey, to destination: ArrowKey) -> [[ArrowKey]] {
        let p1 = ArrowPad.positions[origin]!
        let p2 = ArrowPad.positions[destination]!
        return move(from: p1, to: p2, forbidden: Point(x: 0, y: 0)).map { $0.map { ArrowKey.direction($0) } }
    }

    private func movements(for characters: [Character]) -> [[ArrowKey]] {
        guard characters.count > 1 else { return [[]] }
        return move(from: characters[0], to: characters[1]).flatMap { movement in
            movements(for: Array(characters[1...])).map { remaining in
                movement + [.submit] + remaining
            }
        }
    }

    private func movements(for keys: [ArrowKey]) -> [[ArrowKey]] {
        guard keys.count > 1 else { return [[]] }
        return move(from: keys[0], to: keys[1]).flatMap { movement in
            movements(for: Array(keys[1...])).map { remaining in
                movement + [.submit] + remaining
            }
        }
    }

    private func split(keys: [ArrowKey]) -> [[ArrowKey]] {
        var result: [[ArrowKey]] = []
        var start = 0
        for i in start..<keys.count where keys[i] == .submit {
            result.append(Array(keys[start...i]))
            start = i + 1
        }
        return result
    }

    private func solve(keys: [ArrowKey], depth: Int, maxDepth: Int, cache: inout [Cache: Int]) -> Int {
        var result = 0
        for keys in split(keys: keys) {
            if let cached = cache[.init(keys: keys, depth: depth)] {
                result += cached
                continue
            }
            var partial = Int.max
            for movement in movements(for: [.submit] + keys) {
                if depth == maxDepth {
                    partial = min(movement.count, partial)
                } else {
                    partial = min(solve(keys: movement, depth: depth + 1, maxDepth: maxDepth, cache: &cache), partial)
                }
            }
            cache[.init(keys: keys, depth: depth)] = partial
            result += partial
        }
        return result
    }

    private func solve(input: String, maxDepth: Int) -> Int {
        var result = 0
        var cache: [Cache: Int] = [:]
        for line in input.split(separator: "\n") {
            var minimum = Int.max
            for possibility in movements(for: ["A"] + Array(line)) {
                minimum = min(solve(keys: possibility, depth: 1, maxDepth: maxDepth, cache: &cache), minimum)
            }
            result += minimum * Int(line.dropLast())!
        }
        return result
    }

    func part1(input: String) throws -> Int {
        solve(input: input, maxDepth: 2)
    }

    func part2(input: String) throws -> Int {
        solve(input: input, maxDepth: 25)
    }
}
