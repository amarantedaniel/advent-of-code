import XCTest
@testable import Day18

class SolutionTests: XCTestCase {
    func test_solve1_withSampleInput_shouldReturn26335() {
        let path = Bundle.module.path(forResource: "sample", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve1(input), 26335)
    }

    func test_solve1_withLargeInput_shouldReturn1408133923393() {
        let path = Bundle.module.path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve1(input), 1408133923393)
    }

    func test_solve2_withLargeInput_shouldReturn314455761823725() {
        let path = Bundle.module.path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve2(input), 314455761823725)
    }
}
