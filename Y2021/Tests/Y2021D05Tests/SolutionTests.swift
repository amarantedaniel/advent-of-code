import XCTest
@testable import Y2021D05

class SolutionTests: XCTestCase {
    func test_solve2_withLargeInput() {
        let path = Bundle.module.path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve2(input: input), 19939)
    }
}
