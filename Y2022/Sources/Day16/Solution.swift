import Foundation

struct Valve {
    let id: String
    let flow: Int
    let next: [String]
}

private func getDistancesToValves(valvesDict: [String: Valve]) -> [String: [String: Int]] {
    let valves = Array(valvesDict.values)
    let valveIds = valves.map(\.id)
    var result: [String: [String: Int]] = [:]
    for valve in valves {
        result[valve.id] = [valve.id: 0]
        for id in valve.next {
            result[valve.id]![id] = 1
        }
    }
    for k in valveIds {
        for i in valveIds {
            for j in valveIds {
                let ij = result[i]![j] ?? 9999
                let ik = result[i]![k] ?? 9999
                let kj = result[k]![j] ?? 9999
                if ij > ik + kj {
                    result[i]![j] = ik + kj
                }
            }
        }
    }
    return result
}

struct State: Hashable {
    let player: String
    let player2: String?
    let depth: Int
    let depth2: Int?
    let open: Set<String>

    init(player: String, player2: String? = nil, depth: Int, depth2: Int? = nil, open: Set<String>) {
        self.player = player
        self.player2 = player2
        self.depth = depth
        self.depth2 = depth2
        self.open = open
    }
}

private func navigate(
    valve: Valve,
    valves: [String: Valve],
    distances: [String: [String: Int]],
    open: Set<String> = [],
    depth: Int = 29,
    cache: inout [State: Int]
) -> Int {
    if let cached = cache[State(player: valve.id, depth: depth, open: open)] {
        return cached
    }
    if depth < 1 {
        return 0
    }
    var result = 0
    for other in valves.values where !open.contains(other.id) {
        let distance = distances[valve.id]![other.id]!
        let depth = depth - distance
        if depth < 1 {
            continue
        }
        let flow = other.flow * depth + navigate(
            valve: other,
            valves: valves,
            distances: distances,
            open: open.union([other.id]),
            depth: depth - 1,
            cache: &cache
        )
        result = max(result, flow)
    }
    cache[State(player: valve.id, depth: depth, open: open)] = result
    return result
}

private func navigate(
    human: Valve,
    elephant: Valve,
    valves: [String: Valve],
    distances: [String: [String: Int]],
    open: Set<String> = [],
    humanDepth: Int = 25,
    elephantDepth: Int = 25,
    cache: inout [State: Int]
) -> Int {
    if let cached = cache[State(player: human.id, player2: elephant.id, depth: humanDepth, depth2: elephantDepth, open: open)] {
        return cached
    }
    if let cached = cache[State(player: elephant.id, player2: human.id, depth: elephantDepth, depth2: humanDepth, open: open)] {
        return cached
    }
    if humanDepth < 1, elephantDepth < 1 {
        return 0
    }
    var result = 0
    if humanDepth < elephantDepth {
        for other in valves.values where !open.contains(other.id) {
            let distance = distances[elephant.id]![other.id]!
            let depth = elephantDepth - distance
            if depth < 1 {
                continue
            }
            let flow = other.flow * depth + navigate(
                human: human,
                elephant: other,
                valves: valves,
                distances: distances,
                open: open.union([other.id]),
                humanDepth: humanDepth,
                elephantDepth: depth - 1,
                cache: &cache
            )
            result = max(result, flow)
        }
    } else {
        for other in valves.values where !open.contains(other.id) {
            let distance = distances[human.id]![other.id]!
            let depth = humanDepth - distance
            if depth < 1 {
                continue
            }
            let flow = other.flow * depth + navigate(
                human: other,
                elephant: elephant,
                valves: valves,
                distances: distances,
                open: open.union([other.id]),
                humanDepth: depth - 1,
                elephantDepth: elephantDepth,
                cache: &cache
            )
            result = max(result, flow)
        }
    }
    cache[State(player: human.id, player2: elephant.id, depth: humanDepth, depth2: elephantDepth, open: open)] = result
    cache[State(player: elephant.id, player2: human.id, depth: elephantDepth, depth2: humanDepth, open: open)] = result
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
    var cache: [State: Int] = [:]
    return navigate(valve: first, valves: filtered, distances: distances, cache: &cache)
}

func solve2(input: String) -> Int {
    let valves = Parser.parse(input: input)
    let nodes = valves.reduce(into: [String: Valve]()) {
        $0[$1.id] = $1
    }
    let distances = getDistancesToValves(valvesDict: nodes)
    let first = nodes["AA"]!
    let filtered = nodes.filter { $0.value.flow > 0 }
    var cache: [State: Int] = [:]
    return navigate(human: first, elephant: first, valves: filtered, distances: distances, cache: &cache)
}
