import XCTest
@testable import Day17

class SolutionTests: XCTestCase {
    func test_solve1_withSampleInput_shouldReturn112() {
        let path = Bundle.module.path(forResource: "sample", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve1(input), 112)
    }

    func test_solve1_withLargeInput_shouldReturn269() {
        let path = Bundle.module.path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve1(input), 269)
    }

    func test_solve2_withSampleInput_shouldReturn848() {
        let path = Bundle.module.path(forResource: "sample", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve2(input), 848)
    }

    func test_solve2_withLargeInput_shouldReturn1380() {
        let path = Bundle.module.path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve2(input), 1380)
    }
}
