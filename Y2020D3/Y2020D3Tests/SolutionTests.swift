import XCTest
@testable import Y2020D3

class SolutionTests: XCTestCase {
    func test_solve1_withSampleInput_shouldReturn7() {
        let path = Bundle(for: type(of: self)).path(forResource: "sample", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve1(input), 7)
    }

    func test_solve1_withLargeInput_shouldReturn244() {
        let path = Bundle(for: type(of: self)).path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve1(input), 244)
    }

    func test_solve2_withSampleInput_shouldReturn336() {
        let path = Bundle(for: type(of: self)).path(forResource: "sample", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve2(input), 336)
    }

    func test_solve2_withLargeInput_shouldReturn9406609920() {
        let path = Bundle(for: type(of: self)).path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve2(input), 9_406_609_920)
    }
}
