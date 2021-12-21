import Foundation

enum Parser {
    private static func convertHexToBinary(input: String) -> String {
        input
            .compactMap(\.hexDigitValue)
            .map { String($0, radix: 2).padStart(value: "0", size: 4) }
            .joined()
    }

    static func parse(input: String) -> (Packet, Int) {
        let binary = convertHexToBinary(input: input)
        return parse(binary: Substring(binary))
    }

    static func parse(binary: Substring) -> (Packet, Int) {
        let version = Int(binary.substring(from: 0, to: 2), radix: 2)!
        let id = Int(binary.substring(from: 3, to: 5), radix: 2)!
        guard id != 4 else {
            let (number, size) = parseLiteral(binary: binary.substring(from: 6))
            return (Packet(version: version, id: .literal(number)), size + 6)
        }
        let lengthId = binary.character(at: 6).wholeNumberValue!
        if lengthId == 0 {
            let (packets, size) = parseBasedOnLength(binary: binary)
            return (Packet(version: version, id: makeOperator(id: id, packets: packets)), 22 + size)
        } else {

            let (packets, size) = parseBasedOnCount(binary: binary)
            return (Packet(version: version, id: makeOperator(id: id, packets: packets)), 18 + size)
        }
    }

    private static func parseLiteral(binary: Substring) -> (Int, Int) {
        var index = 0
        var result = ""
        while binary.character(at: index) == "1" {
            result += binary.substring(from: index + 1, to: index + 4)
            index += 5
        }
        result += binary.substring(from: index + 1, to: index + 4)
        return (Int(result, radix: 2)!, index + 5)
    }

    private static func parseBasedOnLength(binary: Substring) -> ([Packet], Int) {
        let lengthBits = 15
        let length = Int(binary.substring(from: 7, to: 7 + lengthBits - 1), radix: 2)!
        var index = 0
        var packets: [Packet] = []
        while index < length {
            let (packet, size) = parse(binary: binary.substring(from: 7 + lengthBits + index))
            packets.append(packet)
            index += size
        }
        return (packets, length)
    }

    private static func parseBasedOnCount(binary: Substring) -> ([Packet], Int) {
        let lengthBits = 11
        let subpacketCount = Int(binary.substring(from: 7, to: 7 + lengthBits - 1), radix: 2)!
        var packets: [Packet] = []
        var packetsSize = 0
        for _ in 0 ..< subpacketCount {
            let (packet, size) = parse(binary: binary.substring(from: 7 + lengthBits + packetsSize))
            packets.append(packet)
            packetsSize += size
        }
        return (packets, packetsSize)
    }

    private static func makeOperator(id: Int, packets: [Packet]) -> PacketId {
        switch id {
        case 0: return .sum(packets)
        case 1: return .product(packets)
        case 2: return .min(packets)
        case 3: return .max(packets)
        case 5: return .greaterThan(packets)
        case 6: return .lessThan(packets)
        case 7: return .equal(packets)
        default: fatalError()
        }
    }
}
