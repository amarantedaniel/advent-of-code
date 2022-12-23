@testable import Day17
import XCTest

class SolutionTests: XCTestCase {
    func test_solve1_sample() {
        let path = Bundle.module.path(forResource: "sample", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve(input: input, goal: 2022), 3068)
    }

    func test_solve1() {
        let path = Bundle.module.path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve(input: input, goal: 2022), 3111)
    }

    func test_solve2_sample() {
        let path = Bundle.module.path(forResource: "sample", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve(input: input, goal: 1000000000000), 1514285714288)
    }

    func test_solve2() {
        let path = Bundle.module.path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve(input: input, goal: 1000000000000), 1526744186042)
    }
}
