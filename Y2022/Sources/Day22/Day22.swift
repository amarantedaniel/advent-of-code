import AdventOfCode
import Foundation

enum Square: Character {
    case outside = " "
    case wall = "#"
    case pathway = "."
    case player = "o"
}

enum Facing {
    case left
    case right
    case up
    case down

    var value: Int {
        switch self {
        case .right:
            return 0
        case .down:
            return 1
        case .left:
            return 2
        case .up:
            return 3
        }
    }

    var vector: Position {
        switch self {
        case .left:
            return Position(x: -1, y: 0)
        case .right:
            return Position(x: 1, y: 0)
        case .up:
            return Position(x: 0, y: -1)
        case .down:
            return Position(x: 0, y: 1)
        }
    }

    func rotatingRight() -> Facing {
        switch self {
        case .left:
            return .up
        case .right:
            return .down
        case .up:
            return .right
        case .down:
            return .left
        }
    }

    func rotatingLeft() -> Facing {
        switch self {
        case .left:
            return .down
        case .right:
            return .up
        case .up:
            return .left
        case .down:
            return .right
        }
    }
}

enum Move {
    case walk(Int)
    case right
    case left
}

struct Position {
    let x: Int
    let y: Int
}

struct Player {
    let position: Position
    let facing: Facing

    init(position: Position, facing: Facing) {
        self.position = position
        self.facing = facing
    }

    func calculate() -> Int {
        let row = position.y + 1
        let column = position.x + 1
        return 1_000 * row + 4 * column + facing.value
    }
}

struct Day22: AdventDay {
    func part1(input: String) -> Int {
        let (maze, moves) = Parser.parse(input: input)
        var player = Player(position: startingPosition(in: maze), facing: .right)
        for move in moves {
            player = perform(move: move, player: player, maze: maze)
        }
        return player.calculate()
    }

    func part2(input: String) throws -> Int {
        throw AdventError.notImplemented
    }

    private func startingPosition(in maze: [[Square]]) -> Position {
        let x = maze[0].firstIndex { $0 == .pathway }!
        return Position(x: x, y: 0)
    }

    private func perform(move: Move, player: Player, maze: [[Square]]) -> Player {
        switch move {
        case let .walk(steps):
            var position = player.position
            let vector = player.facing.vector
            for _ in 0..<steps {
                var attempt = Position(x: position.x + vector.x, y: position.y + vector.y)
                switch player.facing {
                case .left:
                    if attempt.x < 0 || maze[attempt.y][attempt.x] == .outside {
                        attempt = Position(x: maze[attempt.y].count - 1, y: attempt.y)
                    }
                case .right:
                    if attempt.x > maze[attempt.y].count - 1 || maze[attempt.y][attempt.x] == .outside {
                        attempt = Position(x: 0, y: attempt.y)
                    }
                case .up:
                    if attempt.y < 0 || maze[attempt.y][attempt.x] == .outside {
                        attempt = Position(x: attempt.x, y: maze.count - 1)
                    }
                case .down:
                    if attempt.y > maze.count - 1 || maze[attempt.y][attempt.x] == .outside {
                        attempt = Position(x: attempt.x, y: 0)
                    }
                }
                while maze[attempt.y][attempt.x] == .outside {
                    attempt = Position(x: attempt.x + vector.x, y: attempt.y + vector.y)
                }
                if maze[attempt.y][attempt.x] == .wall {
                    break
                }
                position = attempt
            }
            return Player(position: position, facing: player.facing)
        case .right:
            return Player(position: player.position, facing: player.facing.rotatingRight())
        case .left:
            return Player(position: player.position, facing: player.facing.rotatingLeft())
        }
    }
}
