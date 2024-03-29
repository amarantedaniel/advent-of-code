import XCTest
@testable import Day05

class SolutionTests: XCTestCase {
    func test_solve1_withLargeInput_shouldReturn826() {
        let path = Bundle.module.path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve1(input), 826)
    }

    func test_solve2_withLargeInput_shouldReturn678() {
        let path = Bundle.module.path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve2(input), 678)
    }
}
