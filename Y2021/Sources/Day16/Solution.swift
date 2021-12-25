import Foundation

func solve1(input: String) -> Int {
    let (packet, _) = Parser.parse(input: input)
    return packet.countVersions()
}

func solve2(input: String) -> Int {
    let (packet, _) = Parser.parse(input: input)
    return packet.calculate()
}
