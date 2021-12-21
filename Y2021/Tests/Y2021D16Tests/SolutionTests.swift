import XCTest
@testable import Y2021D16

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

//    func test_solve2_withSampleInput() {
//        let path = Bundle.module.path(forResource: "sample", ofType: "txt")!
//        let input = try! String(contentsOfFile: path, encoding: .utf8)
//        XCTAssertEqual(solve2(input: input), 315)
//    }
//
//    func test_solve2_withLargeInput() {
//        let path = Bundle.module.path(forResource: "large", ofType: "txt")!
//        let input = try! String(contentsOfFile: path, encoding: .utf8)
//        XCTAssertEqual(solve2(input: input), 2957)
//    }
}
