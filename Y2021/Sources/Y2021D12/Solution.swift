import Foundation

func countRoutes(from cave: Cave) -> Int {
    if case .end = cave.variant {
        return 1
    }
    var routes = 0
    for neighboor in cave.neighboors where !neighboor.visited {
        neighboor.visit()
        routes += countRoutes(from: neighboor)
        neighboor.visited = false
    }
    return routes
}

func solve1(input: String) -> Int {
    let start = Parser.parse(input: input)
    return countRoutes(from: start)
}
