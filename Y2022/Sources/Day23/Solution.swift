import Foundation

enum Direction {
    case north, south, west, east
}

struct Point: Hashable {
    let x: Int
    let y: Int

    var neighboors: Set<Point> {
        let vectors = [(-1, 0), (1, 0), (0, -1), (0, 1), (-1, -1), (1, -1), (-1, 1), (1, 1)]
        return Set(
            vectors.map { Point(x: x + $0, y: y + $1) }
        )
    }

    func neighboors(direction: Direction) -> Set<Point> {
        let vectors: [(Int, Int)]
        switch direction {
        case .north:
            vectors = [(0, -1), (-1, -1), (1, -1)]
        case .south:
            vectors = [(0, 1), (-1, 1), (1, 1)]
        case .west:
            vectors = [(-1, -1), (-1, 0), (-1, 1)]
        case .east:
            vectors = [(1, -1), (1, 0), (1, 1)]
        }
        return Set(vectors.map { Point(x: x + $0, y: y + $1) })
    }

    func applying(direction: Direction) -> Point {
        switch direction {
        case .west:
            return Point(x: x - 1, y: y)
        case .east:
            return Point(x: x + 1, y: y)
        case .north:
            return Point(x: x, y: y - 1)
        case .south:
            return Point(x: x, y: y + 1)
        }
    }
}

private func parse(input: String) -> Set<Point> {
    var result: Set<Point> = []
    for (y, line) in input.split(separator: "\n").enumerated() {
        for (x, character) in Array(line).enumerated() {
            if character == "#" {
                result.insert(Point(x: x, y: y))
            }
        }
    }
    return result
}

private func countEmpties(set: Set<Point>) -> Int {
    let minX = set.map(\.x).min()!
    let maxX = set.map(\.x).max()!
    let minY = set.map(\.y).min()!
    let maxY = set.map(\.y).max()!
    var count = 0
    for y in minY...maxY {
        for x in minX...maxX where !set.contains(Point(x: x, y: y)) {
            count += 1
        }
    }
    return count
}

private func proposeMovement(elf: Point, elves: Set<Point>, directions: [Direction]) -> Point? {
    for direction in directions where elf.neighboors(direction: direction).intersection(elves).isEmpty {
        return elf.applying(direction: direction)
    }
    return nil
}

private func move(elves: Set<Point>, directions: [Direction]) -> Set<Point> {
    var alreadyProposed: Set<Point> = []
    var duplicates: Set<Point> = []
    var propositions: [Point: Point] = [:]
    for elf in elves {
        if elf.neighboors.intersection(elves).isEmpty {
            continue
        }
        guard let proposed = proposeMovement(elf: elf, elves: elves, directions: directions) else {
            continue
        }
        if alreadyProposed.contains(proposed) {
            duplicates.insert(proposed)
            continue
        }
        alreadyProposed.insert(proposed)
        propositions[elf] = proposed
    }
    propositions = propositions.filter { !duplicates.contains($0.value) }
    return Set(
        elves.map { elf in
            if let proposition = propositions[elf] {
                return proposition
            }
            return elf
        }
    )
}

func solve1(input: String) -> Int {
    var elves = parse(input: input)
    var directions: [Direction] = [.north, .south, .west, .east]
    for _ in 0 ..< 10 {
        elves = move(elves: elves, directions: directions)
        directions = Array(directions[1...] + directions[..<1])
    }
    return countEmpties(set: elves)
}

func solve2(input: String) -> Int {
    var elves = parse(input: input)
    var directions: [Direction] = [.north, .south, .west, .east]
    var round = 1
    while true {
        let moved = move(elves: elves, directions: directions)
        if moved == elves {
            break
        }
        elves = moved
        directions = Array(directions[1...] + directions[..<1])
        round += 1
    }
    return round
}
