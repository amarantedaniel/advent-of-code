import Foundation

func countRoutes(from cave: Cave, canVisitTwice: Bool) -> Int {
    if case .end = cave.variant {
        return 1
    }
    var routes = 0
    for neighboor in cave.neighboors {
        if neighboor.visited {
            if canVisitTwice, case .small = neighboor.variant {
                routes += countRoutes(from: neighboor, canVisitTwice: false)
            }
        } else {
            neighboor.visit()
            routes += countRoutes(from: neighboor, canVisitTwice: canVisitTwice)
            neighboor.visited = false
        }
    }
    return routes
}

func solve1(input: String) -> Int {
    let start = Parser.parse(input: input)
    return countRoutes(from: start, canVisitTwice: false)
}

func solve2(input: String) -> Int {
    let start = Parser.parse(input: input)
    return countRoutes(from: start, canVisitTwice: true)
}
