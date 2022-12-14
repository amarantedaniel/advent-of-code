import Foundation
import Collections

struct Coordinate: Hashable {
    let i: Int
    let j: Int

    static let zero = Coordinate(i: 0, j: 0)
}

typealias Risk = Int

struct CoordinateForRisk: Hashable, Comparable {
    let coordinate: Coordinate
    let steps: Risk

    static func < (lhs: CoordinateForRisk, rhs: CoordinateForRisk) -> Bool {
        lhs.steps < rhs.steps
    }

    static func == (lhs: CoordinateForRisk, rhs: CoordinateForRisk) -> Bool {
        return lhs.coordinate == rhs.coordinate
    }
}

func findPath(cave: Cave) -> Int {
    var visited: Set<Coordinate> = []
    var risks: [Coordinate: Risk] = [:]
    for coordinate in cave.coordinates() {
        risks[coordinate] = Int.max
    }
    risks[.zero] = 0

    var heap = Heap<CoordinateForRisk>()
    heap.insert(.init(coordinate: .zero, steps: 0))

    while !heap.isEmpty {
        let current = heap.removeMin().coordinate
        if current == cave.lastCoordinate {
            return risks[cave.lastCoordinate]!
        }
        visited.insert(current)
        for neighboor in cave.neighboors(from: current) where !visited.contains(neighboor) {
            let risk = risks[current]! + cave.get(neighboor)
            if risk < risks[neighboor]! {
                risks[neighboor] = risk
                heap.insert(.init(coordinate: neighboor, steps: risk))
            }
        }
    }
    fatalError()
}

func solve1(input: String) -> Int {
    return findPath(cave: Parser.parse(input: input, repeating: 1))
}

func solve2(input: String) -> Int {
    return findPath(cave: Parser.parse(input: input, repeating: 5))
}
