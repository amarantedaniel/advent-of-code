import XCTest
@testable import Y2020D02

class SolutionTests: XCTestCase {
    func test_solve1_withSampleInput_shouldReturn2() {
        let path = Bundle.module.path(forResource: "sample", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve1(input), 2)
    }

    func test_solve1_withLargeInput_shouldReturn550() {
        let path = Bundle.module.path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve1(input), 550)
    }

    func test_solve2_withSampleInput_shouldReturn1() {
        let path = Bundle.module.path(forResource: "sample", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve2(input), 1)
    }

    func test_solve2_withLargeInput_shouldReturn634() {
        let path = Bundle.module.path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve2(input), 634)
    }
}
