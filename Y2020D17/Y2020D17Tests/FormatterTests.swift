import XCTest
@testable import Y2020D17

class FormatterTests: XCTestCase {
    func test_withSampleInput_parsingAndFormattingEndsInSameResult() {
        let path = Bundle(for: type(of: self)).path(forResource: "sample", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        let positions = Parser.parse(input: input)
        XCTAssertEqual(Formatter.format(positions: positions), input)
    }

    func test_withLargeInput_parsingAndFormattingEndsInSameResult() {
        let path = Bundle(for: type(of: self)).path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        let positions = Parser.parse(input: input)
        XCTAssertEqual(Formatter.format(positions: positions), input)
    }
}
