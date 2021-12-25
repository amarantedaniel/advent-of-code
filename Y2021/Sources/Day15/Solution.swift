import Foundation

struct Coordinate: Hashable {
    let i: Int
    let j: Int

    static let zero = Coordinate(i: 0, j: 0)
}

typealias Risk = Int

func dijkstra(cave: Cave) -> Int {
    var visited: Set<Coordinate> = []
    var remaining: Set<Coordinate> = [.zero]
    var risks: [Coordinate: Risk] = [:]
    for coordinate in cave.coordinates() {
        risks[coordinate] = Int.max
    }
    risks[.zero] = 0
    while !remaining.isEmpty {
        let node = remaining.min { risks[$0]! < risks[$1]! }!
        remaining.remove(node)
        visited.insert(node)

        for neighboor in cave.neighboors(from: node) where !visited.contains(neighboor) {
            remaining.insert(neighboor)
            let risk = risks[node]! + cave.get(neighboor)
            if risk < risks[neighboor]! {
                risks[neighboor] = risk
            }
        }
    }
    return risks[cave.lastCoordinate]!
}

func solve1(input: String) -> Int {
    return dijkstra(cave: Parser.parse(input: input, repeating: 1))
}

func solve2(input: String) -> Int {
    return dijkstra(cave: Parser.parse(input: input, repeating: 5))
}
