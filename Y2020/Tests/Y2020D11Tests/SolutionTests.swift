import XCTest
@testable import Y2020D11

class SolutionTests: XCTestCase {
    func test_solve2_withSampleInput_shouldReturn26() {
        let path = Bundle.module.path(forResource: "sample", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve2(input), 26)
    }

    func test_solve2_withLargeInput_shouldReturn2199() {
        let path = Bundle.module.path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve2(input), 2199)
    }
}
