import XCTest
@testable import Day16

class ParserTests: XCTestCase {

    func test_parse_literal() {
        let (packet, size) = Parser.parse(input: "D2FE28")
        XCTAssertEqual(packet.version, 6)
        XCTAssertEqual(size, 21)
        switch packet.id {
        case let .literal(number):
            XCTAssertEqual(number, 2021)
        default:
            XCTFail()
        }
    }

    func test_parse_operator() {
        let (packet, size) = Parser.parse(input: "38006F45291200")
        XCTAssertEqual(packet.version, 1)
        XCTAssertEqual(size, 49)
        XCTAssertEqual(packet.subpackets![0].version, 6)
        switch packet.subpackets![0].id {
        case let .literal(number):
            XCTAssertEqual(number, 10)
        default:
            XCTFail()
        }
        XCTAssertEqual(packet.subpackets![1].version, 2)
        switch packet.subpackets![1].id {
        case let .literal(number):
            XCTAssertEqual(number, 20)
        default:
            XCTFail()
        }
    }

    func test_parse_other_operator() {
        let (packet, size) = Parser.parse(input: "EE00D40C823060")
        XCTAssertEqual(packet.version, 7)
        XCTAssertEqual(size, 51)
        XCTAssertEqual(packet.subpackets![0].version, 2)
        switch packet.subpackets![0].id {
        case let .literal(number):
            XCTAssertEqual(number, 1)
        default:
            XCTFail()
        }
        XCTAssertEqual(packet.subpackets![1].version, 4)
        switch packet.subpackets![1].id {
        case let .literal(number):
            XCTAssertEqual(number, 2)
        default:
            XCTFail()
        }
        XCTAssertEqual(packet.subpackets![2].version, 1)
        switch packet.subpackets![2].id {
        case let .literal(number):
            XCTAssertEqual(number, 3)
        default:
            XCTFail()
        }
    }
}
