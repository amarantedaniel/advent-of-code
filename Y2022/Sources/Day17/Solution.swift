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

struct State: Hashable {
    let pieceIndex: Int
    let directionIndex: Int
    let heights: [Int]
}

func solve(input: String, goal: Int) -> Int {
    let directions = parse(input: input)
    let pieces: [Piece] = [.horizontal, .cross, .corner, .vertical, .square]
    var directionIndex = 0
    var pieceIndex = 0
    var piece = getPiece(at: pieceIndex, pieces: pieces)
    var board = Board()
    var position = Position(x: 2, y: 0)
    board.reserveSpace(for: piece)
    var states: [State: (Int, Int)] = [:]
    var height = 0
    while true {
        if position.y == 0 {
            let state = State(
                pieceIndex: pieceIndex % pieces.count,
                directionIndex: directionIndex % directions.count,
                heights: board.getExtraHeightPerColumn()
            )
            if let (previousHeight, previousPieceIndex) = states[state] {
                let extraHeightSinceLast = height - previousHeight
                let extraPiecesSinceLast = pieceIndex - previousPieceIndex
                let howManyLoopsCanFit = (goal - pieceIndex) / extraPiecesSinceLast
                if pieceIndex + extraPiecesSinceLast < goal {
                    pieceIndex += extraPiecesSinceLast * (howManyLoopsCanFit - 1)
                    height += extraHeightSinceLast * (howManyLoopsCanFit - 1)
                    continue
                }
            }
            states[state] = (height, pieceIndex)
        }
        if pieceIndex == goal {
            return height
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
            height += board.settle(piece: piece, at: position)
            pieceIndex += 1
            piece = getPiece(at: pieceIndex, pieces: pieces)
            board.reserveSpace(for: piece)
            position = Position(x: 2, y: 0)
        }
        directionIndex += 1
    }
}
