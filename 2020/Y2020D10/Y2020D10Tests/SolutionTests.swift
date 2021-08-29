import XCTest
@testable import Y2020D10

class SolutionTests: XCTestCase {
    func test_solve2_withSampleInput_shouldReturn8() {
        let path = Bundle(for: type(of: self)).path(forResource: "sample", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve2(input), 8)
    }

    func test_solve2_withLargeInput_shouldReturn1727094849536() {
        let path = Bundle(for: type(of: self)).path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve2(input), 1_727_094_849_536)
    }
}
