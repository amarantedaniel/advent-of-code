import XCTest
@testable import Y2021D7

class SolutionTests: XCTestCase {
    func test_solve1_withLargeInput() {
        let path = Bundle.module.path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve1(input: input), 355989)
    }

    func test_solve2_withLargeInput() {
        let path = Bundle.module.path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve2(input: input), 102245489)
    }
}
