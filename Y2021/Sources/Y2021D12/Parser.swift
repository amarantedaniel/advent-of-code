import Foundation

struct Parser {
    static func parse(input: String) -> Cave {
        var caves: [Cave] = []
        for line in input.split(separator: "\n") {
            let elements = line.split(separator: "-")
            let origin = findOrCreateCave(identifier: String(elements[0]), caves: &caves)
            let destination = findOrCreateCave(identifier: String(elements[1]), caves: &caves)
            origin.neighboors.insert(destination)
            destination.neighboors.insert(origin)
        }
        return caves.first { $0.identifier == "start" }!
    }

    private static  func findOrCreateCave(identifier: String, caves: inout [Cave]) -> Cave {
        if let cave = caves.first(where: { $0.identifier == identifier }) {
            return cave
        }
        let cave = Cave(identifier: identifier)
        caves.append(cave)
        return cave
    }
}
