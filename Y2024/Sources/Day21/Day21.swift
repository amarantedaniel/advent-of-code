import AdventOfCode

enum ArrowKey: Hashable, CustomStringConvertible {
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

struct ArrowPad: Hashable {
    let keys: [ArrowKey]

    static let positions: [ArrowKey: Point] = [
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

    func move(from origin: Character, to destination: Character) -> [ArrowPad] {
        let p1 = Numpad.positions[origin]!
        let p2 = Numpad.positions[destination]!
        return move(from: p1, to: p2, forbidden: Point(x: 0, y: 3)).map { .init(keys: $0.map { ArrowKey.direction($0) }) }
    }

    func move(from origin: ArrowKey, to destination: ArrowKey) -> [ArrowPad] {
        let p1 = ArrowPad.positions[origin]!
        let p2 = ArrowPad.positions[destination]!
        return move(from: p1, to: p2, forbidden: Point(x: 0, y: 0)).map { .init(keys: $0.map { ArrowKey.direction($0) }) }
    }

    private func movements(for characters: [Character]) -> [ArrowPad] {
        if characters.count == 1 {
            return [ArrowPad(keys: [])]
        }
        var result: [ArrowPad] = []
        for movement in move(from: characters[0], to: characters[1]) {
            for remaining in movements(for: Array(characters[1...])) {
                let aux = ArrowPad(keys: movement.keys + [.submit] + remaining.keys)
                result.append(aux)
            }
        }
        return result
    }

    private func movements(for arrowPad: ArrowPad, cache: inout [ArrowPad: [ArrowPad]]) -> [ArrowPad] {
        if arrowPad.keys.count == 1 {
            return [ArrowPad(keys: [])]
        }
        if let result = cache[arrowPad] {
            return result
        }
        var result: [ArrowPad] = []
        for movement in move(from: arrowPad.keys[0], to: arrowPad.keys[1]) {
            for remaining in movements(for: ArrowPad(keys: Array(arrowPad.keys[1...])), cache: &cache) {
                let aux = ArrowPad(keys: movement.keys + [.submit] + remaining.keys)
                result.append(aux)
            }
        }
        cache[arrowPad] = result
        return result
    }

    func calculate(possibilities: [ArrowPad], cache: inout [ArrowPad: [ArrowPad]]) -> [ArrowPad] {
        var result: [ArrowPad] = []
        for possibility in possibilities {
            result.append(contentsOf: movements(for: ArrowPad(keys: [.submit] + possibility.keys), cache: &cache))
        }
        return result
    }

    private func calculate(text: String, count: Int) -> Int {
        var cache: [ArrowPad: [ArrowPad]] = [:]
        var current = movements(for: Array("A\(text)"))
        print("first")
        for value in current {
            print(value)
        }
//        for i in 0..<count {
        current = calculate(possibilities: current, cache: &cache)
//        }
        print("second")
        for value in current {
            print(value)
        }
        return current.map(\.keys.count).min()!
    }

    private func split(keys: [ArrowKey]) -> [[ArrowKey]] {
        var result: [[ArrowKey]] = []
        var currrent: [ArrowKey] = []
        var didStart = false
        for key in keys {
            


        }
        return result
    }

    func part1(input: String) throws -> Int {
        var result = 0
        var cache: [ArrowPad: [ArrowPad]] = [:]
        let keys: [ArrowKey] = [.submit, .direction(.left), .submit, .direction(.right), .submit]
        print(keys.split(separator: .submit))
        print(movements(for: ArrowPad(keys: keys), cache: &cache))
//        for line in input.split(separator: "\n") {
//            let count = calculate(text: String(line), count: 2)
//            result += count * Int(line.dropLast())!
//        }
        return result
    }

    func part2(input: String) throws -> Int {
        var result = 0
        var cache: [ArrowPad: [ArrowPad]] = [:]
//        print("up")
//        for value in calculate(possibilities: [.init(keys: [.direction(.up), .submit])], cache: &cache) {
//            print(value)
//        }
//        print("down")
//        for value in calculate(possibilities: [.init(keys: [.direction(.down), .submit])], cache: &cache) {
//            print(value)
//        }
//        print("left")
//        for value in calculate(possibilities: [.init(keys: [.direction(.left), .submit])], cache: &cache) {
//            print(value)
//        }
//
//        print("right")
//        for value in calculate(possibilities: [.init(keys: [.direction(.right), .submit])], cache: &cache) {
//            print(value)
//        }
//        for line in input.split(separator: "\n") {
//            let count = calculate(text: String(line), count: 25)
//            result += count * Int(line.dropLast())!
//        }
        return result
    }
}
