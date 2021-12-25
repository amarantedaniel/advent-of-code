import XCTest
@testable import Day09

class SolutionTests: XCTestCase {
    func test_solve1_withSampleInput_shouldReturn127() {
        let path = Bundle.module.path(forResource: "sample", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve1(input, preamble: 5), 127)
    }

    func test_solve1_withLargeInput_shouldReturn25918798() {
        let path = Bundle.module.path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve1(input), 25_918_798)
    }

    func test_solve2_withSampleInput_shouldReturn62() {
        let path = Bundle.module.path(forResource: "sample", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve2(input, preamble: 5), 62)
    }

    func test_solve2_withLargeInput_shouldReturn3340942() {
        let path = Bundle.module.path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve2(input), 3_340_942)
    }
}
