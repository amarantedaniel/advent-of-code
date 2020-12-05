import Foundation

enum Move: Character {
    case front = "F"
    case back = "B"
    case right = "R"
    case left = "L"
}

struct Seat: Comparable, CustomStringConvertible {
    let row: Int
    let column: Int

    var seatId: Int {
        row * 8 + column
    }

    var description: String {
        "row: \(row), col: \(column)"
    }

    func nextSeat() -> Seat {
        if column < 7 {
            return Seat(row: row, column: column + 1)
        }
        return Seat(row: row + 1, column: 0)
    }

    static func < (lhs: Seat, rhs: Seat) -> Bool {
        if lhs.row == rhs.row {
            return lhs.column < rhs.column
        }
        return lhs.row < rhs.row
    }
}

func findSeat(moves: [Move]) -> Seat {
    var moves = moves
    let row = findRow(moves: &moves, min: 0, max: 127)
    let column = findColumn(moves: &moves, min: 0, max: 7)
    return Seat(row: row, column: column)
}

func findRow(moves: inout [Move], min: Int, max: Int) -> Int {
    let move = moves.removeFirst()
    let middle = min + ((max - min) / 2)
    switch move {
    case .front:
        return findRow(moves: &moves, min: min, max: middle)
    case .back:
        return findRow(moves: &moves, min: middle + 1, max: max)
    default:
        moves.insert(move, at: 0)
        return min + ((max - min) / 2)
    }
}

func findColumn(moves: inout [Move], min: Int, max: Int) -> Int {
    if moves.isEmpty {
        return max
    }
    let move = moves.removeFirst()
    let middle = min + ((max - min) / 2)
    switch move {
    case .right:
        return findColumn(moves: &moves, min: middle + 1, max: max)
    case .left:
        return findColumn(moves: &moves, min: min, max: middle)
    default:
        return middle
    }
}

let input = try! String(contentsOfFile: "input.txt", encoding: .utf8)
let seats = input
    .split(separator: "\n")
    .map { $0.compactMap { Move(rawValue: $0) } }
    .map(findSeat(moves:))
    .sorted()

var previousSeat = seats.first!
for seat in seats.dropFirst() {
    let expectedNextSeat = previousSeat.nextSeat()
    if expectedNextSeat != seat {
        print(expectedNextSeat.seatId)
    }
    previousSeat = seat
}
