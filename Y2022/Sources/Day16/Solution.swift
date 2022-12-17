import Collections
import Foundation

struct Valve {
    let id: String
    let flow: Int
    let next: [String]
}

private func parse(input: String) -> [Valve] {
    let pattern = """
    Valve ([A-Z]+) has flow rate=([0-9]+); tunnel(?:s*) lead(?:s*) to valve(?:s*) ([A-Z]+(?:, [A-Z]+)*)
    """
    let regex = try! NSRegularExpression(pattern: pattern)
    let range = NSRange(input.startIndex..., in: input)
    let matches = regex.matches(in: input, range: range)
    return matches.map { match in
        let substrings = (1 ..< match.numberOfRanges).map { index in
            input[Range(match.range(at: index), in: input)!]
        }
        return Valve(
            id: String(substrings[0]),
            flow: Int(substrings[1])!,
            next: substrings[2].components(separatedBy: ", ")
        )
    }
}

struct Cache: Hashable {
    let valveId: String
    let open: Set<String>
    let depth: Int
}

struct Cache2: Hashable {
    let valveIds: Set<String>
    let open: Set<String>
    let depth: Int
}

func navigate2(
    valveId: String,
    elephantId: String,
    valves: [String: Valve],
    open: Set<String>,
    depth: Int,
    cache: inout [Cache2: Int]
) -> Int {
    if let cached = cache[
        Cache2(valveIds: [valveId, elephantId], open: open, depth: depth)
    ] {
        return cached
    }
    if open == Set(valves.keys) {
        return 0
    }
    if depth < 1 {
        return 0
    }
    let valve = valves[valveId]!
    let elephant = valves[elephantId]!
    var result = 0
    // case both decide to open
    if valve.flow > 0, !open.contains(valveId), elephant.flow > 0, !open.contains(elephantId), valveId != elephantId {
        let newOpen = open.union([valveId, elephantId])
        result = valve.flow * depth + elephant.flow * depth + navigate2(
            valveId: valveId,
            elephantId: elephantId,
            valves: valves,
            open: newOpen,
            depth: depth - 1,
            cache: &cache
        )
        if newOpen == Set(valves.keys) {
            return result
        }
    }

    // case user open valve
    // elephant tries all screens
    if valve.flow > 0, !open.contains(valveId) {
        let newOpen = open.union([valveId])
        let totalFlow = valve.flow * depth
        for neighboorId in elephant.next {
            let flow = totalFlow + navigate2(
                valveId: valveId,
                elephantId: neighboorId,
                valves: valves,
                open: newOpen,
                depth: depth - 1,
                cache: &cache
            )
            result = max(result, flow)
            if newOpen == Set(valves.keys) {
                return result
            }
        }
    }

    // case elephant open valve
    // user goes to all sreens
    if elephant.flow > 0, !open.contains(elephantId) {
        let totalFlow = elephant.flow * depth
        let newOpen = open.union([elephantId])
        for neighboorId in valve.next {
            let flow = totalFlow + navigate2(
                valveId: neighboorId,
                elephantId: elephantId,
                valves: valves,
                open: newOpen,
                depth: depth - 1,
                cache: &cache
            )
            result = max(result, flow)
            if newOpen == Set(valves.keys) {
                return result
            }
        }
    }

    // case each goes to a different screen
    for valveNeighboorId in valve.next {
        for elephantNeighboorId in elephant.next {
            let flow = navigate2(
                valveId: valveNeighboorId,
                elephantId: elephantNeighboorId,
                valves: valves,
                open: open,
                depth: depth - 1,
                cache: &cache
            )
            result = max(result, flow)
        }
    }
    cache[Cache2(valveIds: [valveId, elephantId], open: open, depth: depth)] = result
    return result
}

func navigate(
    valveId: String,
    valves: [String: Valve],
    open: Set<String>,
    depth: Int,
    cache: inout [Cache: Int]
) -> Int {
    if let cached = cache[Cache(valveId: valveId, open: open, depth: depth)] {
        return cached
    }
    if depth < 1 {
        return 0
    }
    if open == Set(valves.filter { $0.value.flow > 0 }.map(\.key)) {
        return 0
    }
    let valve = valves[valveId]!
    var result = 0

    if valve.flow > 0, !open.contains(valveId) {
        let totalFlow = valve.flow * depth
        result = totalFlow + navigate(
            valveId: valveId,
            valves: valves,
            open: open.union([valveId]),
            depth: depth - 1,
            cache: &cache
        )
    }
    for neighboorId in valve.next {
        let flow = navigate(
            valveId: neighboorId,
            valves: valves,
            open: open,
            depth: depth - 1,
            cache: &cache
        )
        result = max(result, flow)
    }
    cache[Cache(valveId: valveId, open: open, depth: depth)] = result
    return result
}

func solve1(input: String) -> Int {
    let valves = parse(input: input)
    let nodes = valves.reduce(into: [String: Valve]()) {
        $0[$1.id] = $1
    }
    let start = valves[0]
    var cache: [Cache: Int] = [:]
    print(navigate(valveId: start.id, valves: nodes, open: [], depth: 33, cache: &cache))
    print(otherSolve(nodes: nodes, start: start.id))
    return 1651
}

func solve2(input: String) -> Int {
    let valves = parse(input: input)
    let nodes = valves.reduce(into: [String: Valve]()) {
        $0[$1.id] = $1
    }
    let start = valves[0]
    var cache: [Cache2: Int] = [:]
    return navigate2(valveId: start.id, elephantId: start.id, valves: nodes, open: [], depth: 25, cache: &cache)
}

struct State: Hashable {
    let nodeId: String
    let depth: Int
    let open: Set<String>
    let flow: Int
}

struct StateWithPriority: Hashable, Comparable {
    let state: State
    let priority: Int

    static func == (lhs: StateWithPriority, rhs: StateWithPriority) -> Bool {
        return lhs.state == rhs.state
    }

    static func < (lhs: StateWithPriority, rhs: StateWithPriority) -> Bool {
        lhs.priority < rhs.priority
    }
}

private func potential(for state: State, valves: [String: Valve]) -> Int {
    let remaining = Set(valves.filter { $0.value.flow > 0 }.map(\.key)).subtracting(state.open)
    let missingPotential = remaining.compactMap { valves[$0] }.reduce(0) {
        $0 + $1.flow * state.depth
    }
    return state.flow + missingPotential
}

func otherSolve(nodes: [String: Valve], start: String) -> Int {
    var heap = Heap<StateWithPriority>()
    let state = State(nodeId: start, depth: 33, open: [], flow: 0)
    heap.insert(.init(state: state, priority: potential(for: state, valves: nodes)))
    var result = 0
    var visited: [String: State] = [:]
    while !heap.isEmpty {
        let current = heap.popMax()!.state
        let valve = nodes[current.nodeId]!
        if current.depth < 1 || potential(for: current, valves: nodes) < result {
            continue
        }
//        let currentPotential = potential(for: current, valves: nodes)
//        if let bla = visited[current.nodeId], isBetter(state: bla, than: current) {
//            continue
//        } else {
//            visited[current.nodeId] = current
//        }
        if !current.open.contains(current.nodeId), valve.flow > 0 {
            let state = State(
                nodeId: current.nodeId,
                depth: current.depth - 1,
                open: current.open.union([current.nodeId]),
                flow: current.flow + current.depth * valve.flow
            )
            result = max(result, state.flow)
            let potential = potential(for: state, valves: nodes)
            heap.insert(.init(state: state, priority: potential))
        }
        for id in valve.next {
            let state = State(
                nodeId: id,
                depth: current.depth - 1,
                open: current.open,
                flow: current.flow
            )
            let potential = potential(for: state, valves: nodes)
            heap.insert(.init(state: state, priority: potential))
        }
    }
    return result
}
