import XCTest
@testable import Day04

class SolutionTests: XCTestCase {
    func test_solve1_withSampleInput_shouldReturn2() {
        let path = Bundle.module.path(forResource: "sample", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve1(input), 2)
    }

    func test_solve1_withLargeInput_shouldReturn208() {
        let path = Bundle.module.path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve1(input), 208)
    }

    func test_solve2_withSampleInput_shouldReturn2() {
        let path = Bundle.module.path(forResource: "sample", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve2(input), 2)
    }

    func test_solve2_withValidInput_shouldReturn4() {
        let path = Bundle.module.path(forResource: "valid", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve2(input), 4)
    }

    func test_solve2_withInvalidInput_shouldReturn() {
        let path = Bundle.module.path(forResource: "invalid", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve2(input), 0)
    }

    func test_solve2_withLargeInput_shouldReturn167() {
        let path = Bundle.module.path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve2(input), 167)
    }
}
