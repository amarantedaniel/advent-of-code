struct Navigator {
    func findSeat(moves: [Move]) -> Seat {
        var moves = moves
        let row = findRow(moves: &moves, min: 0, max: 127)
        let column = findColumn(moves: &moves, min: 0, max: 7)
        return Seat(row: row, column: column)
    }

    private func findRow(moves: inout [Move], min: Int, max: Int) -> Int {
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

    private func findColumn(moves: inout [Move], min: Int, max: Int) -> Int {
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
}
