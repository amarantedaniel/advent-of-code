import AdventOfCode

struct Position: Hashable {
    let x: Int
    let y: Int
}

enum Direction: Character, Hashable {
    case up = "^"
    case down = "v"
    case left = "<"
    case right = ">"
    func turnRight() -> Direction {
        switch self {
        case .up: .right
        case .down: .left
        case .left: .up
        case .right: .down
        }
    }
}

struct Guard: Hashable {
    let position: Position
    let direction: Direction
}

enum Square: String {
    case obstacle = "#"
    case path = "."
}

struct Day06: AdventDay {
    private func parse(input: String) -> (Guard, [[Square]]) {
        var `guard`: Guard!
        var result: [[Square]] = []
        for (x, line) in input.split(separator: "\n").enumerated() {
            var row: [Square] = []
            for (y, character) in Array(line).enumerated() {
                switch character {
                case ".":
                    row.append(.path)
                case "#":
                    row.append(.obstacle)
                default:
                    row.append(.path)
                    `guard` = Guard(
                        position: Position(x: x, y: y),
                        direction: Direction(rawValue: character)!
                    )
                }
            }
            result.append(row)
        }
        return (`guard`, result)
    }

    private func position(inFrontOf guard: Guard, in map: [[Square]]) -> Position? {
        let position: Position
        switch `guard`.direction {
        case .up:
            position = Position(x: `guard`.position.x - 1, y: `guard`.position.y)
        case .down:
            position = Position(x: `guard`.position.x + 1, y: `guard`.position.y)
        case .left:
            position = Position(x: `guard`.position.x, y: `guard`.position.y - 1)
        case .right:
            position = Position(x: `guard`.position.x, y: `guard`.position.y + 1)
        }
        if isInside(grid: map, position: position) {
            return position
        }
        return nil
    }

    private func isInside(grid: [[Square]], position: Position) -> Bool {
        position.x >= 0
            && position.y >= 0
            && position.x < grid.count
            && position.y < grid[position.x].count
    }

    private func move(guard: Guard, map: [[Square]]) -> Guard? {
        guard let next = position(inFrontOf: `guard`, in: map) else {
            return nil
        }
        switch map[next.x][next.y] {
        case .obstacle:
            return Guard(
                position: `guard`.position,
                direction: `guard`.direction.turnRight()
            )
        case .path:
            return Guard(position: next, direction: `guard`.direction)
        }
    }

    private func findPath(guard: Guard, map: [[Square]]) -> Set<Position> {
        var `guard` = `guard`
        var positions: Set<Position> = [`guard`.position]
        while let nextGuard = move(guard: `guard`, map: map) {
            `guard` = nextGuard
            positions.insert(`guard`.position)
        }
        return positions
    }

    func part1(input: String) throws -> Int {
        let (`guard`, map) = parse(input: input)
        return findPath(guard: `guard`, map: map).count
    }

    private func hasLoop(guard: Guard, map: [[Square]]) -> Bool {
        var states: Set<Guard> = [`guard`]
        var `guard` = `guard`
        while let next = move(guard: `guard`, map: map) {
            if states.contains(next) {
                return true
            }
            `guard` = next
            states.insert(next)
        }
        return false
    }

    func part2(input: String) throws -> Int {
        var (`guard`, map) = parse(input: input)
        let path = findPath(guard: `guard`, map: map)
        var loopCount = 0
        for position in path where position != `guard`.position {
            map[position.x][position.y] = .obstacle
            if hasLoop(guard: `guard`, map: map) {
                loopCount += 1
            }
            map[position.x][position.y] = .path
        }
        return loopCount
    }
}
