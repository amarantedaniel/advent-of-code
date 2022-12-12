import XCTest
@testable import Day08

class SolutionTests: XCTestCase {

    func test_solve1() {
        let path = Bundle.module.path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve1(input: input), 1859)
    }

    func test_solve2() {
        let path = Bundle.module.path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve2(input: input), 332640)
    }
}
