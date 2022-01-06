import XCTest
@testable import Day19

class SolutionTests: XCTestCase {

    func test_solve1_withSampleInput() {
        let path = Bundle.module.path(forResource: "sample", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve1(input: input), 79)
    }

//    func test_solve1_withLargeInput() {
//        let path = Bundle.module.path(forResource: "large", ofType: "txt")!
//        let input = try! String(contentsOfFile: path, encoding: .utf8)
//        XCTAssertEqual(solve1(input: input), 0)
//    }
//
//    func test_solve2_withSampleInput() {
//        let path = Bundle.module.path(forResource: "sample2", ofType: "txt")!
//        let input = try! String(contentsOfFile: path, encoding: .utf8)
//        XCTAssertEqual(solve2(input: input), 0)
//    }
//
//    func test_solve2_withLargeInput() {
//        let path = Bundle.module.path(forResource: "large", ofType: "txt")!
//        let input = try! String(contentsOfFile: path, encoding: .utf8)
//        XCTAssertEqual(solve2(input: input), 0)
//    }
}
