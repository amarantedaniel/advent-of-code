import XCTest
@testable import Y2020D1

class Y2020D1Tests: XCTestCase {

    func test_solve1_withSampleInput_shouldReturn514579() {
        let path = Bundle(for: type(of: self)).path(forResource: "sample", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve1(input), 514579)

    }

    func test_solve1_withLargeInput_shouldReturn646779() {
        let path = Bundle(for: type(of: self)).path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve1(input), 646779)
    }

    func test_solve2_withSampleInput_shouldReturn241861950() {
        let path = Bundle(for: type(of: self)).path(forResource: "sample", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve2(input), 241861950)
    }

    func test_solve2_withLargeInput_shouldReturn246191688() {
        let path = Bundle(for: type(of: self)).path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve2(input), 246191688)
    }
}
