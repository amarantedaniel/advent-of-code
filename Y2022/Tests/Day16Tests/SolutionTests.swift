@testable import Day16
import XCTest

class SolutionTests: XCTestCase {
    func test_solve1_sample() {
        let path = Bundle.module.path(forResource: "sample", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve1(input: input), 1651)
    }

    func test_solve1() {
        let path = Bundle.module.path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve1(input: input), 1641)
    }

    func test_solve2_sample() {
        let path = Bundle.module.path(forResource: "sample", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve2(input: input), 1707)
    }

    func test_solve2() {
//        let path = Bundle.module.path(forResource: "large", ofType: "txt")!
//        let input = try! String(contentsOfFile: path, encoding: .utf8)
//        XCTAssertEqual(solve2(input: input), 0)
    }
}
