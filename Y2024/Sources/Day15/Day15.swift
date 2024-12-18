import AdventOfCode

struct Map<Value> {
    var map: [[Value]]

    subscript(point: Point) -> Value {
        get {
            map[point.y][point.x]
        }
        set(newValue) {
            map[point.y][point.x] = newValue
        }
    }

    func firstPoint(where condition: (Value) -> Bool) -> Point? {
        for y in 0..<map.count {
            for x in 0..<map[y].count {
                if condition(map[y][x]) {
                    return Point(x: x, y: y)
                }
            }
        }
        return nil
    }

    func allPoints(where condition: (Value) -> Bool) -> [Point] {
        var boxes: [Point] = []
        for y in 0..<map.count {
            for x in 0..<map[y].count {
                if condition(map[y][x]) {
                    boxes.append(Point(x: x, y: y))
                }
            }
        }
        return boxes
    }
}

struct V2Box: Equatable {
    let left: Point
    let right: Point
}

struct Point: Equatable, AdditiveArithmetic {
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

enum Direction: Character {
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

enum Square: Character {
    case robot = "@"
    case wall = "#"
    case box = "O"
    case path = "."
}

enum SquareV2: Character {
    case robot = "@"
    case wall = "#"
    case box1 = "["
    case box2 = "]"
    case path = "."
}

enum Parser {
    static func parse(input: String) -> (Map<Square>, [Direction]) {
        let parts = input.components(separatedBy: "\n\n")
        return (
            Map(
                map: parts[0].split(separator: "\n").map { line in
                    line.compactMap(Square.init(rawValue:))
                }
            ),
            parts[1].compactMap(Direction.init(rawValue:))
        )
    }

    static func parseLargeMap(input: String) -> (Map<SquareV2>, [Direction]) {
        let parts = input.components(separatedBy: "\n\n")
        var map: [[SquareV2]] = []

        for line in parts[0].split(separator: "\n") {
            var row: [SquareV2] = []
            for character in line {
                switch character {
                case "@":
                    row.append(contentsOf: [.robot, .path])
                case "#":
                    row.append(contentsOf: [.wall, .wall])
                case "O":
                    row.append(contentsOf: [.box1, .box2])
                case ".":
                    row.append(contentsOf: [.path, .path])
                default:
                    break
                }
            }
            map.append(row)
        }
        return (
            Map(map: map),
            parts[1].compactMap(Direction.init(rawValue:))
        )
    }
}

struct Day15: AdventDay {
    func move(start: Point, map: inout Map<Square>, direction: Direction) -> Point {
        let vector = direction.vector()
        var point = start
        while true {
            point += vector
            switch map[point] {
            case .robot, .box:
                break
            case .wall:
                return start
            case .path:
                var current = point
                while current != start {
                    let next = current - vector
                    let aux = map[current]
                    map[current] = map[next]
                    map[next] = aux
                    current = next
                }
                return start + vector
            }
        }
    }

    func part1(input: String) throws -> Int {
        var (map, directions) = Parser.parse(input: input)
        var robot = map.firstPoint(where: { $0 == .robot })!
        for direction in directions {
            robot = move(start: robot, map: &map, direction: direction)
        }
        return map
            .allPoints(where: { $0 == .box })
            .reduce(0) { $0 + 100 * $1.y + $1.x }
    }

    func move(start: Point, map: inout Map<SquareV2>, direction: Direction) -> Point {
        let vector = direction.vector()
        let next = start + vector
        switch map[next] {
        case .path:
            let aux = map[start]
            map[start] = map[next]
            map[next] = aux
            return next
        case .robot, .wall:
            return start
        case .box1, .box2:
            let box = fullBox(for: next, map: map)
            guard canMove(box: box, map: map, vector: vector) else {
                return start
            }
            let boxes = movableBoxes(from: box, map: map, vector: vector)
            for box in boxes {
                map[box.left] = .path
                map[box.right] = .path
            }
            for box in boxes {
                map[box.left + vector] = .box1
                map[box.right + vector] = .box2
            }
            let aux = map[start]
            map[start] = map[next]
            map[next] = aux
            return next
        }
    }

    private func fullBox(for piece: Point, map: Map<SquareV2>) -> V2Box {
        switch map[piece] {
        case .box1:
            let vector = Direction.right.vector()
            return V2Box(left: piece, right: piece + vector)
        case .box2:
            let vector = Direction.left.vector()
            return V2Box(left: piece + vector, right: piece)
        default:
            fatalError()
        }
    }

    private func canMove(box: V2Box, map: Map<SquareV2>, vector: Point) -> Bool {
        for next in [box.left + vector, box.right + vector] {
            if next == box.left || next == box.right {
                continue
            }
            switch map[next] {
            case .robot, .wall:
                return false
            case .path:
                continue
            case .box1, .box2:
                let nextBox = fullBox(for: next, map: map)
                if !canMove(box: nextBox, map: map, vector: vector) {
                    return false
                }
            }
        }
        return true
    }

    private func movableBoxes(
        from box: V2Box, map: Map<SquareV2>, vector: Point
    ) -> [V2Box] {
        var boxes: [V2Box] = [box]
        for next in [box.left + vector, box.right + vector] {
            if next == box.left || next == box.right {
                continue
            }
            switch map[next] {
            case .robot, .wall, .path:
                continue
            case .box1, .box2:
                let nextBox = fullBox(for: next, map: map)
                if !boxes.contains(nextBox) {
                    boxes.append(contentsOf: movableBoxes(from: nextBox, map: map, vector: vector))
                }
            }
        }
        return boxes
    }

    func part2(input: String) throws -> Int {
        var (map, directions) = Parser.parseLargeMap(input: input)
        var robot = map.firstPoint(where: { $0 == .robot })!
        for direction in directions {
            robot = move(start: robot, map: &map, direction: direction)
        }
        return map
            .allPoints(where: { $0 == .box1 })
            .reduce(0) { $0 + 100 * $1.y + $1.x }
    }
}
