import XCTest
@testable import Day18

class ParserTests: XCTestCase {

    func test_parse_withSampleInput() {
        let path = Bundle.module.path(forResource: "sample2", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        let trees = Parser.parse(input: input)
        let output = trees.map(\.description).joined(separator: "\n") + "\n"
        XCTAssertEqual(input, output)
    }
}
