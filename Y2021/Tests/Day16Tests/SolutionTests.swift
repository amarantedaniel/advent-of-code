import XCTest
@testable import Day16

class SolutionTests: XCTestCase {

    func test_solve1_withSampleInput() {
        XCTAssertEqual(solve1(input: "8A004A801A8002F478"), 16)
        XCTAssertEqual(solve1(input: "620080001611562C8802118E34"), 12)
        XCTAssertEqual(solve1(input: "C0015000016115A2E0802F182340"), 23)
        XCTAssertEqual(solve1(input: "A0016C880162017C3686B18A3D4780"), 31)
    }

    func test_solve1_withLargeInput() {
        let path = Bundle.module.path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve1(input: input), 854)
    }

    func test_solve2_withSampleInput() {
        XCTAssertEqual(solve2(input: "C200B40A82"), 3)
        XCTAssertEqual(solve2(input: "04005AC33890"), 54)
        XCTAssertEqual(solve2(input: "880086C3E88112"), 7)
        XCTAssertEqual(solve2(input: "CE00C43D881120"), 9)
        XCTAssertEqual(solve2(input: "D8005AC2A8F0"), 1)
        XCTAssertEqual(solve2(input: "F600BC2D8F"), 0)
        XCTAssertEqual(solve2(input: "9C005AC2F8F0"), 0)
        XCTAssertEqual(solve2(input: "9C0141080250320F1802104A08"), 1)
    }

    func test_solve2_withLargeInput() {
        let path = Bundle.module.path(forResource: "large", ofType: "txt")!
        let input = try! String(contentsOfFile: path, encoding: .utf8)
        XCTAssertEqual(solve2(input: input), 186189840660)
    }
}
