import XCTest
@testable import Y2020D17

class Position3DTests: XCTestCase {
    func test_adjacents_shouldNotContainCurrentPosition() {
        let position = Position3D(x: 0, y: 0, z: 0)
        XCTAssertFalse(position.adjacents().contains(position))
    }

    func test_adjacents_shouldHave26Adjacents() {
        let position = Position3D(x: 0, y: 0, z: 0)
        XCTAssertEqual(position.adjacents().count, 26)
    }
}
