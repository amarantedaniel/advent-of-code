@testable import Day17
import XCTest

class SolutionTests: XCTestCase {
    func test_solve1() {
        let path = Bundle.module.path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve1(input: input), 3111)
    }

    func test_solve2() {
        let path = Bundle.module.path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve2(input: input), 0)
    }
}
