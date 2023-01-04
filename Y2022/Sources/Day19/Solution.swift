import Foundation

enum Mineral: String, CustomStringConvertible, Comparable {
    static func < (lhs: Mineral, rhs: Mineral) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    case ore
    case clay
    case obsidian
    case geode

    var description: String {
        rawValue
    }
}

struct Cost {
    let mineral: Mineral
    let value: Int
}

struct Blueprint {
    let prices: [Mineral: [Cost]]
}

private func parse(input: String) -> [Blueprint] {
    let pattern = """
    Each ore robot costs ([0-9]+) ore. Each clay robot costs ([0-9]+) ore. Each obsidian robot costs ([0-9]+) ore and ([0-9]+) clay. Each geode robot costs ([0-9]+) ore and ([0-9]+) obsidian.
    """
    let regex = try! NSRegularExpression(pattern: pattern)
    let range = NSRange(input.startIndex..., in: input)
    let matches = regex.matches(in: input, range: range)
    return matches.map { match in
        let numbers = (1 ..< match.numberOfRanges).compactMap { index in
            Int(input[Range(match.range(at: index), in: input)!])
        }
        return Blueprint(
            prices: [
                .ore: [Cost(mineral: .ore, value: numbers[0])],
                .clay: [Cost(mineral: .ore, value: numbers[1])],
                .obsidian: [Cost(mineral: .ore, value: numbers[2]), Cost(mineral: .clay, value: numbers[3])],
                .geode: [Cost(mineral: .ore, value: numbers[4]), Cost(mineral: .obsidian, value: numbers[5])]
            ]
        )
    }
}

private func canPurchase(costs: [Cost], minerals: [Mineral: Int]) -> Bool {
    for cost in costs {
        if minerals[cost.mineral]! < cost.value {
            return false
        }
    }
    return true
}

private func increment(robots: [Mineral: Int], minerals: [Mineral: Int]) -> [Mineral: Int] {
    var minerals = minerals
    for (robot, count) in robots {
        minerals[robot] = minerals[robot]! + count
    }
    return minerals
}

private func buy(costs: [Cost], minerals: [Mineral: Int]) -> [Mineral: Int] {
    var minerals = minerals
    for cost in costs {
        minerals[cost.mineral] = minerals[cost.mineral]! - cost.value
    }
    return minerals
}

struct State: Hashable, Equatable, CustomStringConvertible {
    let robots: [Mineral: Int]
    let minerals: [Mineral: Int]
    let time: Int

    var description: String {
        "Robots: \(robots), minerals: \(minerals), time: \(time)"
    }
}

@available(macOS 10.15, *)
func solve1(input: String) async -> Int {
    let blueprints = parse(input: input)
//    let result = await withTaskGroup(of: Int.self) { taskGroup in
//        for (index, blueprint) in blueprints.enumerated() {
//            taskGroup.addTask {
//                solve(blueprint: blueprint) * (index + 1)
//            }
//        }
//        return await taskGroup.reduce(0, +)
//    }
    var result = 0
    for (index, blueprint) in blueprints.enumerated() {
        print("start blueprint")
        result += solve(blueprint: blueprint) * (index + 1)
        print("end blueprint")
    }
    print("result: \(result)")
    return 0
}

func canBuy(state: State, robot: Mineral, costs: [Cost], maximums: [Mineral: Int]) -> Bool {
    if robot == .ore, state.robots[.ore]! >= maximums[.ore]! {
        return false
    }

    if robot == .clay, state.robots[.clay]! >= maximums[.clay]! {
        return false
    }

    if robot == .obsidian, state.robots[.obsidian]! >= maximums[.obsidian]! {
        return false
    }

    if costs.contains(where: { $0.mineral == .clay }), state.robots[.clay]! == 0 {
        return false
    }
    if costs.contains(where: { $0.mineral == .obsidian }), state.robots[.obsidian]! == 0 {
        return false
    }
    return true
}

func adding(robot: Mineral, to robots: [Mineral: Int]) -> [Mineral: Int] {
    var robots = robots
    robots[robot] = robots[robot]! + 1
    return robots
}

func buy(state: State, robot: Mineral, costs: [Cost], maximums: [Mineral: Int]) -> State? {
    guard canBuy(state: state, robot: robot, costs: costs, maximums: maximums) else { return nil }
    let oreCost = costs.first(where: { $0.mineral == .ore })?.value ?? 0
    let clayCost = costs.first(where: { $0.mineral == .clay })?.value ?? 0
    let obsidianCost = costs.first(where: { $0.mineral == .obsidian })?.value ?? 0
    let missingOre = oreCost - state.minerals[.ore]!
    let missingClay = clayCost - state.minerals[.clay]!
    let missingObsidian = obsidianCost - state.minerals[.obsidian]!
    let daysToFarmOre = Int((Double(missingOre) / Double(state.robots[.ore]!)).rounded(.up))
    let daysToFarmClay = state.robots[.clay]! == 0 ? 0 : Int((Double(missingClay) / Double(state.robots[.clay]!)).rounded(.up))
    let daysToFarmObsidian = state.robots[.obsidian]! == 0 ? 0 : Int((Double(missingObsidian) / Double(state.robots[.obsidian]!)).rounded(.up))
    let time = max(daysToFarmOre, max(daysToFarmClay, daysToFarmObsidian)) + 1
    let minerals: [Mineral: Int] = [
        .ore: state.minerals[.ore]! + (time * state.robots[.ore]!) - oreCost,
        .clay: state.minerals[.clay]! + (time * state.robots[.clay]!) - clayCost,
        .obsidian: state.minerals[.obsidian]! + (time * state.robots[.obsidian]!) - obsidianCost,
        .geode: time * state.robots[.geode]!
    ]
    return State(
        robots: adding(robot: robot, to: state.robots),
        minerals: minerals,
        time: state.time + time
    )
}

func calculateMaxGeodes(from state: State, maxTime: Int) -> Int {
    let next = state.robots[.geode]! * (maxTime - state.time)
    return state.minerals[.geode]! + next
}

func solve(blueprint: Blueprint) -> Int {
    let costs = blueprint.prices.values.flatMap { $0 }
    let maxOre = costs.filter { $0.mineral == .ore }.max(by: { $0.value < $1.value })!.value
    let maxClay = costs.filter { $0.mineral == .clay }.max(by: { $0.value < $1.value })!.value
    let maxObsidian = costs.filter { $0.mineral == .obsidian }.max(by: { $0.value < $1.value })!.value
    let maxes: [Mineral: Int] = [.ore: maxOre, .clay: maxClay, .obsidian: maxObsidian, .geode: Int.max]

    var visited: Set<State> = []
    var queue: [State] = [
        .init(
            robots: [.ore: 1, .clay: 0, .geode: 0, .obsidian: 0],
            minerals: [.ore: 0, .clay: 0, .geode: 0, .obsidian: 0],
            time: 0
        )
    ]
    var result = 0
    var count = 0
    while !queue.isEmpty {
        let state = queue.removeFirst()
        if state.time > 24 {
            continue
        }
        result = max(result, calculateMaxGeodes(from: state, maxTime: 24))
        if visited.contains(state) {
            continue
        }
        visited.insert(state)
        for (robot, costs) in blueprint.prices {
            if let new = buy(state: state, robot: robot, costs: costs, maximums: maxes) {
                queue.append(new)
            }
        }
        count += 1
    }
    print(result)
    return 0
}

//
// func solve(blueprint: Blueprint) -> Int {
//    var visited: Set<State> = []
//    var queue: [State] = [
//        .init(
//            robots: [.ore: 1, .clay: 0, .geode: 0, .obsidian: 0],
//            minerals: [.ore: 0, .clay: 0, .geode: 0, .obsidian: 0],
//            time: 0
//        )
//    ]
//    let costs = blueprint.prices.values.flatMap { $0 }
//    let maxOre = costs.filter { $0.mineral == .ore }.max(by: { $0.value < $1.value })!.value
//    let maxClay = costs.filter { $0.mineral == .clay }.max(by: { $0.value < $1.value })!.value
//    let maxObsidian = costs.filter { $0.mineral == .obsidian }.max(by: { $0.value < $1.value })!.value
//    let maxes: [Mineral: Int] = [.ore: maxOre, .clay: maxClay, .obsidian: maxObsidian, .geode: Int.max]
//    var result = 0
//    while !queue.isEmpty {
//        let state = queue.removeFirst()
//        result = max(result, state.minerals[.geode]!)
////        print(state.time)
////        print(state)
//        if state.time >= 24 {
//            continue
//        }
//        if visited.contains(state) {
//            continue
//        }
//        visited.insert(state)
//        queue.append(
//            State(robots: state.robots, minerals: increment(robots: state.robots, minerals: state.minerals), time: state.time + 1)
//        )
//        for (robot, costs) in blueprint.prices where canPurchase(costs: costs, minerals: state.minerals) {
//            if state.robots[robot]! >= maxes[robot]! {
//                continue
//            }
//            let newMinerals = buy(costs: costs, minerals: state.minerals)
//            var newRobots = state.robots
//            newRobots[robot] = newRobots[robot]! + 1
//            let possibleNextState = State(
//                robots: newRobots,
//                minerals: increment(robots: state.robots, minerals: newMinerals),
//                time: state.time + 1
//            )
//            queue.append(possibleNextState)
//        }
//    }
//    return result
// }

func solve2(input: String) -> Int {
    0
}
