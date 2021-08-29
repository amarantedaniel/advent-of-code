import XCTest
@testable import Y2020D15

class SolutionTests: XCTestCase {
    func test_solve1_withLargeInput_shouldReturn403() {
        let input = "16,12,1,0,15,7,11"
        XCTAssertEqual(solve1(input), 403)
    }

    func test_solve2_withLargeInput_shouldReturn6823() {
        let input = "16,12,1,0,15,7,11"
        XCTAssertEqual(solve2(input), 6823)
    }
}
