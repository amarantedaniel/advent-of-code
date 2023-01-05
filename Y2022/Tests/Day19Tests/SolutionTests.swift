@testable import Day19
import XCTest

class SolutionTests: XCTestCase {
    func test_solve1() async {
        let path = Bundle.module.path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        let result = await solve1(input: input)
        XCTAssertEqual(result, 1427)
    }

    func test_solve2() async {
        let path = Bundle.module.path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        let result = await solve2(input: input)
        XCTAssertEqual(result, 4400)
    }
}
