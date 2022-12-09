import Foundation

struct Position: Equatable, Hashable {
    let x: Int
    let y: Int
}

enum Direction: String {
    case up = "U"
    case down = "D"
    case right = "R"
    case left = "L"
}

struct Move {
    let direction: Direction
    let steps: Int
}

func parse(input: String) -> [Move] {
    input
        .split(separator: "\n")
        .map {
            let parts = $0.split(separator: " ")
            return Move(
                direction: Direction(rawValue: String(parts[0]))!,
                steps: Int(parts[1])!
            )
        }
}

func perform(move: Move, rope: [Position], visited: inout Set<Position>) -> [Position] {
    var rope = rope
    for _ in 0 ..< move.steps {
        rope = performMove(direction: move.direction, rope: rope)
        visited.insert(rope.last!)
    }
    return rope
}

func performMove(direction: Direction, rope: [Position]) -> [Position] {
    var newRope: [Position] = []
    var prev = move(head: rope[0], direction: direction)
    newRope.append(prev)
    for i in 1 ..< rope.count {
        let knot = moveTail(head: prev, tail: rope[i])
        newRope.append(knot)
        prev = knot
    }
    return newRope
}

func move(head: Position, direction: Direction) -> Position {
    switch direction {
    case .up:
        return Position(x: head.x, y: head.y + 1)
    case .down:
        return Position(x: head.x, y: head.y - 1)
    case .right:
        return Position(x: head.x + 1, y: head.y)
    case .left:
        return Position(x: head.x - 1, y: head.y)
    }
}

func moveTail(head: Position, tail: Position) -> Position {
    if isTouching(head: head, tail: tail) {
        return tail
    }
    let diffX = min(max(head.x - tail.x, -1), 1)
    let diffY = min(max(head.y - tail.y, -1), 1)
    return Position(x: tail.x + diffX, y: tail.y + diffY)
}

func isTouching(head: Position, tail: Position) -> Bool {
    abs(tail.x - head.x) <= 1 && abs(tail.y - head.y) <= 1
}

func solve1(input: String) -> Int {
    let moves = parse(input: input)
    var rope = Array(repeating: Position(x: 0, y: 0), count: 2)
    var visited = Set<Position>()
    for move in moves {
        rope = perform(move: move, rope: rope, visited: &visited)
    }
    return visited.count
}

func solve2(input: String) -> Int {
    let moves = parse(input: input)
    var rope = Array(repeating: Position(x: 0, y: 0), count: 10)
    var visited = Set<Position>()
    for move in moves {
        rope = perform(move: move, rope: rope, visited: &visited)
    }
    return visited.count
}
