import XCTest
@testable import Y2020D07

class SolutionTests: XCTestCase {
    func test_solve1_withSampleInput_shouldReturn4() {
        let path = Bundle.module.path(forResource: "sample", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve1(input), 4)
    }

    func test_solve1_withLargeInput_shouldReturn103() {
        let path = Bundle.module.path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve1(input), 103)
    }

    func test_solve2_withSampleInput_shouldReturn32() {
        let path = Bundle.module.path(forResource: "sample", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve2(input), 32)
    }

    func test_solve2_withLargeInput_shouldReturn1469() {
        let path = Bundle.module.path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve2(input), 1469)
    }
}
