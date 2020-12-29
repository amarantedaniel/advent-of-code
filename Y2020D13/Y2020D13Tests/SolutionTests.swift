import XCTest
@testable import Y2020D13

class SolutionTests: XCTestCase {
    func test_solve1_withSampleInput_shouldReturn295() {
        let path = Bundle(for: type(of: self)).path(forResource: "sample", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve1(input), 295)
    }

    func test_solve1_withLargeInput_shouldReturn1915() {
        let path = Bundle(for: type(of: self)).path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve1(input), 1915)
    }

    func test_solve2_withLargeInput_shouldReturn294354277694107() {
        let path = Bundle(for: type(of: self)).path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve2(input), 294354277694107)
    }
}
