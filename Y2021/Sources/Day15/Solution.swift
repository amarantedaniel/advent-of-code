import Foundation
import Shared

struct Coordinate: Hashable {
    let i: Int
    let j: Int

    static let zero = Coordinate(i: 0, j: 0)
}

typealias Risk = Int

func findPath(cave: Cave) -> Int {
    var visited: Set<Coordinate> = []
    var risks: [Coordinate: Risk] = [:]
    for coordinate in cave.coordinates() {
        risks[coordinate] = Int.max
    }
    risks[.zero] = 0

    var heap = Heap<Coordinate, Risk>(priority: <)
    heap.insert(.zero, priority: 0)

    while !heap.isEmpty {
        let current = heap.extract()!
        if current == cave.lastCoordinate {
            return risks[cave.lastCoordinate]!
        }
        visited.insert(current)
        for neighboor in cave.neighboors(from: current) where !visited.contains(neighboor) {
            let risk = risks[current]! + cave.get(neighboor)
            if risk < risks[neighboor]! {
                risks[neighboor] = risk
                heap.insert(neighboor, priority: risk)
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
