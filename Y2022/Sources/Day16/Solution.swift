import Foundation

struct Valve {
    let id: String
    let flow: Int
    let next: [String]
}

private func getDistancesToValves(valvesDict: [String: Valve]) -> [String: [String: Int]] {
    let valves = Array(valvesDict.values)
    var idToIndex: [String: Int] = [:]
    var indexToId: [Int: String] = [:]
    for index in 0..<valves.count {
        idToIndex[valves[index].id] = index
        indexToId[index] = valves[index].id
    }
    var distances = Array(
        repeating: Array(repeating: 9999, count: valves.count),
        count: valves.count
    )
    for valve in valves {
        let index = idToIndex[valve.id]!
        distances[index][index] = 0
        for id in valve.next {
            let jindex = idToIndex[id]!
            distances[index][jindex] = 1
        }
    }
    for k in 0..<valves.count {
        for i in 0..<valves.count {
            for j in 0..<valves.count {
                if distances[i][j] > distances[i][k] + distances[k][j] {
                    distances[i][j] = distances[i][k] + distances[k][j]
                }
            }
        }
    }
    var result: [String: [String: Int]] = [:]
    for valve in valves {
        let index = idToIndex[valve.id]!
        var ids: [String: Int] = [:]
        for i in 0..<valves.count {
            let id = indexToId[i]!
            if valvesDict[id]!.flow > 0 {
                let distance = distances[index][i]
                ids[id] = distance
            }
        }
        result[valve.id] = ids
    }
    return result
}

private func navigate(
    valve: Valve,
    valves: [String: Valve],
    distances: [String: [String: Int]],
    open: Set<String> = [],
    depth: Int = 29
) -> Int {
    if depth < 1 {
        return 0
    }
    var result = 0
    for other in valves.values where !open.contains(other.id) {
        let distance = distances[valve.id]![other.id]!
        let depth = depth - distance
        let flow = other.flow * depth + navigate(
            valve: other,
            valves: valves,
            distances: distances,
            open: open.union([other.id]),
            depth: depth - 1
        )
        result = max(result, flow)
    }
    return result
}

private func navigate(
    human: Valve,
    elephant: Valve,
    valves: [String: Valve],
    distances: [String: [String: Int]],
    open: Set<String> = [],
    humanDepth: Int = 25,
    elephantDepth: Int = 25
) -> Int {
    if humanDepth < 1, elephantDepth < 1 {
        return 0
    }
    var result = 0
    if humanDepth < elephantDepth {
        for other in valves.values where !open.contains(other.id) {
            let distance = distances[elephant.id]![other.id]!
            let depth = elephantDepth - distance
            let flow = other.flow * depth + navigate(
                human: human,
                elephant: other,
                valves: valves,
                distances: distances,
                open: open.union([other.id]),
                humanDepth: humanDepth,
                elephantDepth: depth - 1
            )
            result = max(result, flow)
        }
    } else {
        for other in valves.values where !open.contains(other.id) {
            let distance = distances[human.id]![other.id]!
            let depth = humanDepth - distance
            let flow = other.flow * depth + navigate(
                human: other,
                elephant: elephant,
                valves: valves,
                distances: distances,
                open: open.union([other.id]),
                humanDepth: depth - 1,
                elephantDepth: elephantDepth
            )
            result = max(result, flow)
        }
    }
    return result
}

func solve1(input: String) -> Int {
    let valves = Parser.parse(input: input)
    let nodes = valves.reduce(into: [String: Valve]()) {
        $0[$1.id] = $1
    }
    let distances = getDistancesToValves(valvesDict: nodes)
    let first = nodes["AA"]!
    let filtered = nodes.filter { $0.value.flow > 0 }
    return navigate(valve: first, valves: filtered, distances: distances)
}

func solve2(input: String) -> Int {
    let valves = Parser.parse(input: input)
    let nodes = valves.reduce(into: [String: Valve]()) {
        $0[$1.id] = $1
    }
    let distances = getDistancesToValves(valvesDict: nodes)
    let first = nodes["AA"]!
    let filtered = nodes.filter { $0.value.flow > 0 }
    return navigate(human: first, elephant: first, valves: filtered, distances: distances)
}
