import XCTest
@testable import Y2020D6

class SolutionTests: XCTestCase {
    func test_solve1_withSampleInput_shouldReturn11() {
        let path = Bundle.module.path(forResource: "sample", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve1(input), 11)
    }

    func test_solve1_withLargeInput_shouldReturn6291() {
        let path = Bundle.module.path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve1(input), 6291)
    }

    func test_solve2_withSampleInput_shouldReturn6() {
        let path = Bundle.module.path(forResource: "sample", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve2(input), 6)
    }

    func test_solve2_withLargeInput_shouldReturn3052() {
        let path = Bundle.module.path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve2(input), 3052)
    }
}
