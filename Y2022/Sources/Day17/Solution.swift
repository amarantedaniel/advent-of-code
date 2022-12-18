import Foundation

enum Direction {
    case left
    case right
    case down
}

struct Position {
    let x: Int
    let y: Int

    func move(direction: Direction) -> Position {
        switch direction {
        case .left:
            return Position(x: x - 1, y: y)
        case .right:
            return Position(x: x + 1, y: y)
        case .down:
            return Position(x: x, y: y + 1)
        }
    }
}

private func parse(input: String) -> [Direction] {
    input.compactMap {
        switch $0 {
        case ">":
            return .right
        case "<":
            return .left
        default:
            return nil
        }
    }
}

private func getPiece(at index: Int, pieces: [Piece]) -> Piece {
    pieces[index % pieces.count]
}

private func getDirection(at index: Int, directions: [Direction]) -> Direction {
    directions[index % directions.count]
}

func solve1(input: String) -> Int {
    let directions = parse(input: input)
    let pieces: [Piece] = [.horizontal, .cross, .corner, .vertical, .square]
    var directionIndex = 0
    var pieceIndex = 0
    var piece = getPiece(at: pieceIndex, pieces: pieces)
    var board = Board()
    var position = Position(x: 2, y: 0)
    board.reserveSpace(for: piece)
    while true {
        if pieceIndex == 2022 {
            return board.getHeight()
        }
        let direction = getDirection(at: directionIndex, directions: directions)
        var attempt = position.move(direction: direction)
        if board.canMove(position: attempt, piece: piece) {
            position = attempt
        }
        attempt = position.move(direction: .down)
        if board.canMove(position: attempt, piece: piece) {
            position = attempt
        } else {
            board.settle(piece: piece, at: position)
            pieceIndex += 1
            piece = getPiece(at: pieceIndex, pieces: pieces)
            board.reserveSpace(for: piece)
            position = Position(x: 2, y: 0)
        }
        directionIndex += 1
    }
}

func solve2(input: String) -> Int {
    0
}
