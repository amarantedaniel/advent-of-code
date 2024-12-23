import AdventOfCode

enum ArrowPadKey: Hashable, CustomStringConvertible {
    case direction(Direction)
    case submit

    var description: String {
        switch self {
        case let .direction(direction):
            direction.rawValue
        case .submit:
            "A"
        }
    }
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

enum ArrowPad {
    static let positions: [ArrowPadKey: Point] = [
        .direction(.up): Point(x: 1, y: 0), .submit: Point(x: 2, y: 0),
        .direction(.left): Point(x: 0, y: 1), .direction(.down): Point(x: 1, y: 1), .direction(.right): Point(x: 2, y: 1),
    ]
}

enum Direction: String, CustomStringConvertible {
    case up = "^"
    case down = "v"
    case left = "<"
    case right = ">"

    var description: String {
        rawValue
    }

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
    func move(from origin: Character, to destination: Character) -> [[Direction]] {
        let p1 = Numpad.positions[origin]!
        let p2 = Numpad.positions[destination]!

        if p1 == p2 {
            return [[]]
        }

        if p1.x == p2.x {
            return [Array(repeating: p2.y > p1.y ? .down : .up, count: abs(p2.y - p1.y))]
        }

        if p1.y == p2.y {
            return [Array(repeating: p2.x > p1.x ? .right : .left, count: abs(p2.x - p1.x))]
        }

        let forbiddenPoint = Point(x: 0, y: 3)

        return [
            Array(repeating: p2.y > p1.y ? .down : .up, count: abs(p2.y - p1.y)) + Array(repeating: p2.x > p1.x ? .right : .left, count: abs(p2.x - p1.x)),
            Array(repeating: p2.x > p1.x ? .right : .left, count: abs(p2.x - p1.x)) + Array(repeating: p2.y > p1.y ? .down : .up, count: abs(p2.y - p1.y))
        ].filter { directions in
            var point = p1
            for direction in directions {
                point = point + direction.vector()
                if point == forbiddenPoint {
                    return false
                }
            }
            return true
        }
    }

    func move(from origin: ArrowPadKey, to destination: ArrowPadKey) -> [[Direction]] {
        let p1 = ArrowPad.positions[origin]!
        let p2 = ArrowPad.positions[destination]!

        if p1 == p2 {
            return [[]]
        }

        if p1.x == p2.x {
            return [Array(repeating: p2.y > p1.y ? .down : .up, count: abs(p2.y - p1.y))]
        }

        if p1.y == p2.y {
            return [Array(repeating: p2.x > p1.x ? .right : .left, count: abs(p2.x - p1.x))]
        }

        let forbiddenPoint = Point(x: 0, y: 0)

        return [
            Array(repeating: p2.y > p1.y ? .down : .up, count: abs(p2.y - p1.y)) + Array(repeating: p2.x > p1.x ? .right : .left, count: abs(p2.x - p1.x)),
            Array(repeating: p2.x > p1.x ? .right : .left, count: abs(p2.x - p1.x)) + Array(repeating: p2.y > p1.y ? .down : .up, count: abs(p2.y - p1.y))
        ].filter { directions in
            var point = p1
            for direction in directions {
                point = point + direction.vector()
                if point == forbiddenPoint {
                    return false
                }
            }
            return true
        }
    }

    private func movements(for characters: Array<Character>) -> [[ArrowPadKey]] {
        if characters.count == 1 {
            return [[]]
        }
        var result: [[ArrowPadKey]] = []
        for possibility in move(from: characters[0], to: characters[1]) {
            for possibility2 in movements(for: Array(characters[1...])) {
                let aux = possibility.map { ArrowPadKey.direction($0) } + [.submit] + possibility2
                result.append(aux)
            }
        }
        return result
    }

    private func movements(for characters: Array<ArrowPadKey>) -> [[ArrowPadKey]] {
        if characters.count == 1 {
            return [[]]
        }
        var result: [[ArrowPadKey]] = []
        for possibility in move(from: characters[0], to: characters[1]) {
            for possibility2 in movements(for: Array(characters[1...])) {
                let aux = possibility.map { ArrowPadKey.direction($0) } + [.submit] + possibility2
                result.append(aux)
            }
        }
        return result
    }

    func doStuff(possibilities: [[ArrowPadKey]]) -> [[ArrowPadKey]] {
        var result: [[ArrowPadKey]] = []
        for possibility in possibilities {
            result.append(contentsOf: movements(for: [.submit] + possibility))
        }
        return result
    }

    private func calculate(text: String) -> Int {
        print("started text \(text)")
        var current = movements(for: Array("A\(text)"))
        for i in 0..<25 {
            print("index: \(i)")
            current = doStuff(possibilities: current)
        }
        return current.map(\.count).min()!
    }

    func part1(input: String) throws -> Int {
        var result = 0
        for line in input.split(separator: "\n") {
            let count = calculate(text: String(line))
            result += count * Int(line.dropLast())!
        }
        return result
    }

    func part2(input: String) throws -> Int {
        throw AdventError.notImplemented
    }
}
