import Foundation

extension String {
    func padStart(value: String, size: Int) -> String {
        return String(repeating: value, count: size - count) + self
    }
}

extension Substring {
    func substring(from start: Int, to end: Int) -> Substring {
        return self[index(startIndex, offsetBy: start) ... index(startIndex, offsetBy: end)]
    }

    func substring(from start: Int) -> Substring {
        return self[index(startIndex, offsetBy: start)...]
    }

    func character(at position: Int) -> Character {
        return self[index(startIndex, offsetBy: position)]
    }
}

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
            let lengthBits = 15
            let length = Int(binary.substring(from: 7, to: 7 + lengthBits - 1), radix: 2)!
            var index = 0
            var packets: [Packet] = []
            while index < length {
                let (packet, size) = parse(binary: binary.substring(from: 7 + lengthBits + index))
                packets.append(packet)
                index += size
            }
            return (Packet(version: version, id: .operator(packets)), 7 + lengthBits + length)
        } else {
            let lengthBits = 11
            let subpacketCount = Int(binary.substring(from: 7, to: 7 + lengthBits - 1), radix: 2)!
            var packets: [Packet] = []
            var packetsSize = 0
            for _ in 0 ..< subpacketCount {
                let (packet, size) = parse(binary: binary.substring(from: 7 + lengthBits + packetsSize))
                packets.append(packet)
                packetsSize += size
            }
            return (Packet(version: version, id: .operator(packets)), 7 + lengthBits + packetsSize)
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
}

enum PacketId {
    case literal(Int)
    case `operator`([Packet])
}

struct Packet {
    let version: Int
    let id: PacketId

    func countVersions() -> Int {
        guard case .operator(let packets) = id else {
            return version
        }
        return packets.reduce(version) { sum, packet in sum + packet.countVersions() }
    }
}

func solve1(input: String) -> Int {
    let (packet, _) = Parser.parse(input: input)
    return packet.countVersions()
}

func solve2(input: String) -> Int {
    return 0
}
