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

    for (previous, next) in zip(seats, seats.dropFirst()) {
        let expectedNextSeat = previous.nextSeat()
        if expectedNextSeat != next {
            return expectedNextSeat.seatId
        }
    }
    return nil
}
