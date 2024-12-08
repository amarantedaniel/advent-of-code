import AdventOfCode

struct Bounds {
    let width: Int
    let height: Int
}

struct Position: Hashable {
    let x: Int
    let y: Int

    func isInside(bounds: Bounds) -> Bool {
        x >= 0 && y >= 0 && x < bounds.height && y < bounds.width
    }
}

struct Day08: AdventDay {
    private func parse(input: String) -> ([Character: [Position]], Bounds) {
        let lines = input.split(separator: "\n")
        let bounds = Bounds(width: lines[0].count, height: lines.count)
        var antennas: [Character: [Position]] = [:]
        for (x, line) in input.split(separator: "\n").enumerated() {
            for (y, character) in Array(line).enumerated() {
                guard character != "." else { continue }
                antennas[character, default: []].append(Position(x: x, y: y))
            }
        }
        return (antennas, bounds)
    }

    func part1(input: String) throws -> Int {
        let (antennas, bounds) = parse(input: input)
        var positions: Set<Position> = []
        for value in antennas.values {
            positions.formUnion(singleAntinodes(for: value, in: bounds))
        }
        return positions.count
    }

    private func singleAntinodes(
        for antennas: [Position], in bounds: Bounds
    ) -> Set<Position> {
        var result: Set<Position> = []
        for i in 0..<antennas.count {
            for j in (i + 1)..<antennas.count {
                let dx = antennas[j].x - antennas[i].x
                let dy = antennas[j].y - antennas[i].y
                let antinode1 = Position(x: antennas[j].x + dx, y: antennas[j].y + dy)
                let antinode2 = Position(x: antennas[i].x - dx, y: antennas[i].y - dy)
                if antinode1.isInside(bounds: bounds) {
                    result.insert(antinode1)
                }
                if antinode2.isInside(bounds: bounds) {
                    result.insert(antinode2)
                }
            }
        }
        return result
    }

    func part2(input: String) throws -> Int {
        let (antennas, bounds) = parse(input: input)
        var positions: Set<Position> = []
        for value in antennas.values {
            positions.formUnion(antinodes(for: value, in: bounds))
        }
        return positions.count
    }

    private func antinodes(for antennas: [Position], in bounds: Bounds) -> Set<Position> {
        var result: Set<Position> = []
        for i in 0..<antennas.count {
            for j in (i + 1)..<antennas.count {
                result.formUnion(
                    antinodes(from: antennas[i], to: antennas[j], in: bounds)
                )
                result.formUnion(
                    antinodes(from: antennas[j], to: antennas[i], in: bounds)
                )
            }
        }
        return result
    }

    private func antinodes(from: Position, to: Position, in bounds: Bounds) -> [Position] {
        var result: [Position] = []
        let dx = to.x - from.x
        let dy = to.y - from.y
        var antinode = to
        while antinode.isInside(bounds: bounds) {
            result.append(antinode)
            antinode = Position(x: antinode.x + dx, y: antinode.y + dy)
        }
        return result
    }
}
