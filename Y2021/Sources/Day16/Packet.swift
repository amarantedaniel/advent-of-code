import Foundation

enum PacketId {
    case literal(Int)
    case sum([Packet])
    case product([Packet])
    case min([Packet])
    case max([Packet])
    case greaterThan([Packet])
    case lessThan([Packet])
    case equal([Packet])
}

struct Packet {
    let version: Int
    let id: PacketId

    var subpackets: [Packet]? {
        switch id {
        case .literal:
            return nil
        case .sum(let packets),
             .product(let packets),
             .min(let packets),
             .max(let packets),
             .greaterThan(let packets),
             .lessThan(let packets),
             .equal(let packets):
            return packets
        }
    }

    func countVersions() -> Int {
        guard let packets = subpackets else { return version }
        return packets.reduce(version) { $0 + $1.countVersions() }
    }

    func calculate() -> Int {
        switch id {
        case .literal(let value):
            return value
        case .sum(let packets):
            return packets.reduce(0) { $0 + $1.calculate() }
        case .product(let packets):
            return packets.reduce(1) { $0 * $1.calculate() }
        case .min(let packets):
            return packets.map { $0.calculate() }.min()!
        case .max(let packets):
            return packets.map { $0.calculate() }.max()!
        case .greaterThan(let packets):
            return packets[0].calculate() > packets[1].calculate() ? 1 : 0
        case .lessThan(let packets):
            return packets[0].calculate() < packets[1].calculate() ? 1 : 0
        case .equal(let packets):
            return packets[0].calculate() == packets[1].calculate() ? 1 : 0
        }
    }
}
