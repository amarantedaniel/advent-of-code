import XCTest
@testable import Y2020D17

class SolutionTests: XCTestCase {
    func test_solve1_withSampleInput_shouldReturn112() {
        let path = Bundle(for: type(of: self)).path(forResource: "sample", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve1(input), 112)
    }

    func test_solve1_withLargeInput_shouldReturn269() {
        let path = Bundle(for: type(of: self)).path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve1(input), 269)
    }
}
