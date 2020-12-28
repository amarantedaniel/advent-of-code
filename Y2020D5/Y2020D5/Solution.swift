public func solve1(_ input: String) -> Int? {
    let navigator = Navigator()
    return Parser.parse(input: input)
        .map { navigator.findSeat(moves: $0) }
        .map(\.seatId)
        .max()
}

public func solve2(_ input: String) -> Int? {
    let navigator = Navigator()
    let seats = Parser.parse(input: input)
        .map { navigator.findSeat(moves: $0) }
        .sorted()

    var previousSeat = seats.first!
    for seat in seats.dropFirst() {
        let expectedNextSeat = previousSeat.nextSeat()
        if expectedNextSeat != seat {
            return expectedNextSeat.seatId
        }
        previousSeat = seat
    }
    return nil
}
