import XCTest
@testable import Y2020D5

class NavigatorTests: XCTestCase {
    func test_withSampleInputBFFFBBFRRR_shouldReturnCorrectSeat() {
        let navigator = Navigator()
        let moves = parse(input: "BFFFBBFRRR")
        let seat = navigator.findSeat(moves: moves)
        XCTAssertEqual(seat.row, 70)
        XCTAssertEqual(seat.column, 7)
        XCTAssertEqual(seat.seatId, 567)
    }

    func test_withSampleInputFFFBBBFRRR_shouldReturnCorrectSeat() {
        let navigator = Navigator()
        let moves = parse(input: "FFFBBBFRRR")
        let seat = navigator.findSeat(moves: moves)
        XCTAssertEqual(seat.row, 14)
        XCTAssertEqual(seat.column, 7)
        XCTAssertEqual(seat.seatId, 119)
    }

    func test_withSampleInputBBFFBBFRLL_shouldReturnCorrectSeat() {
        let navigator = Navigator()
        let moves = parse(input: "BBFFBBFRLL")
        let seat = navigator.findSeat(moves: moves)
        XCTAssertEqual(seat.row, 102)
        XCTAssertEqual(seat.column, 4)
        XCTAssertEqual(seat.seatId, 820)
    }

    private func parse(input: String) -> [Move] {
        Array(input).compactMap(Move.init(rawValue:))
    }
}
