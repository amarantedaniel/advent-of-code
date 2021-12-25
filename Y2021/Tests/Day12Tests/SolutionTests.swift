import XCTest
@testable import Day12

class SolutionTests: XCTestCase {

    func test_solve1_withSampleInput() {
        let path = Bundle.module.path(forResource: "sample", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve1(input: input), 10)
    }

    func test_solve1_withMediumSampleInput() {
        let path = Bundle.module.path(forResource: "sample-medium", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve1(input: input), 19)
    }

    func test_solve1_withLargeSampleInput() {
        let path = Bundle.module.path(forResource: "sample-large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve1(input: input), 226)
    }

    func test_solve1_withLargeInput() {
        let path = Bundle.module.path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve1(input: input), 5104)
    }

    func test_solve2_withSampleInput() {
        let path = Bundle.module.path(forResource: "sample", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve2(input: input), 36)
    }

    func test_solve2_withMediumSampleInput() {
        let path = Bundle.module.path(forResource: "sample-medium", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve2(input: input), 103)
    }

    func test_solve2_withLargeSampleInput() {
        let path = Bundle.module.path(forResource: "sample-large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve2(input: input), 3509)
    }

    func test_solve2_withLargeInput() {
        let path = Bundle.module.path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve2(input: input), 149220)
    }
}
