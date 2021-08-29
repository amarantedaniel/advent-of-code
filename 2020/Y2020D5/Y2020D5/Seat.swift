struct Seat: Comparable {
    let row: Int
    let column: Int

    var seatId: Int {
        row * 8 + column
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
