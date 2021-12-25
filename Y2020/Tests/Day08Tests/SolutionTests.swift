import XCTest
@testable import Day08

class SolutionTests: XCTestCase {
    func test_solve1_withSampleInput_shouldReturn5() {
        let path = Bundle.module.path(forResource: "sample", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve1(input), 5)
    }

    func test_solve1_withLargeInput_shouldReturn1489() {
        let path = Bundle.module.path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve1(input), 1489)
    }

    func test_solve2_withSampleInput_shouldReturn8() {
        let path = Bundle.module.path(forResource: "sample", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve2(input), 8)
    }

    func test_solve2_withLargeInput_shouldReturn1539() {
        let path = Bundle.module.path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve2(input), 1539)
    }
}
