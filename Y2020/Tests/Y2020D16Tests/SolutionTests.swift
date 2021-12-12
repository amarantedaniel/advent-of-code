import XCTest
@testable import Y2020D16

class SolutionTests: XCTestCase {
    func test_solve2_withLargeInput_shouldReturn51240700105297() {
        let path = Bundle.module.path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve2(input), 51_240_700_105_297)
    }
}
