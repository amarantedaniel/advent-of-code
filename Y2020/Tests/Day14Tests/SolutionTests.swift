import XCTest
@testable import Day14

class SolutionTests: XCTestCase {
    func test_solve1_withSampleInput_shouldReturn165() {
        let path = Bundle.module.path(forResource: "sample1", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve1(input), 165)
    }

    func test_solve1_withLargeInput_shouldReturn13865835758282() {
        let path = Bundle.module.path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve1(input), 13_865_835_758_282)
    }

    func test_solve2_withSampleInput_shouldReturn208() {
        let path = Bundle.module.path(forResource: "sample2", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve2(input), 208)
    }

    func test_solve2_withLargeInput_shouldReturn4195339838136() {
        let path = Bundle.module.path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve2(input), 4_195_339_838_136)
    }
}
