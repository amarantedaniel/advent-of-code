import AdventOfCode

struct Day16: AdventDay {
    func part1(input: String) -> Int {
        let (packet, _) = Parser.parse(input: input)
        return packet.countVersions()
    }

    func part2(input: String) -> Int {
        let (packet, _) = Parser.parse(input: input)
        return packet.calculate()
    }
}
