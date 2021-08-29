import XCTest
@testable import Y2020D12

class SolutionTests: XCTestCase {
    func test_solve1_withSampleInput_shouldReturn25() {
        let path = Bundle(for: type(of: self)).path(forResource: "sample", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve1(input), 25)
    }

    func test_solve1_withLargeInput_shouldReturn1106() {
        let path = Bundle(for: type(of: self)).path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve1(input), 1106)
    }

    func test_solve2_withSampleInput_shouldReturn286() {
        let path = Bundle(for: type(of: self)).path(forResource: "sample", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve2(input), 286)
    }

    func test_solve2_withLargeInput_shouldReturn107281() {
        let path = Bundle(for: type(of: self)).path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve2(input), 107_281)
    }
}
