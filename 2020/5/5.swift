import Foundation

enum Move: Character {
    case front = "F"
    case back = "B"
    case right = "R"
    case left = "L"
}

func findSeat(moves: inout [Move]) -> Int {
    let row = findRow(moves: &moves, min: 0, max: 127)
    let column = findColumn(moves: &moves, min: 0, max: 7)
    return row * 8 + column
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
let allMoves = input.split(separator: "\n").map { line in line.compactMap { Move(rawValue: $0) } }

var highest = 0
for moves in allMoves {
    var moves = moves
    let seatId = findSeat(moves: &moves)
    if seatId > highest {
        highest = seatId
    }
}

print(highest)
