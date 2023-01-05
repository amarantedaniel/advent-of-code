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

struct Blueprint {
    let prices: [Mineral: [Mineral: Int]]
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
                .ore: [.ore: numbers[0]],
                .clay: [.ore: numbers[1]],
                .obsidian: [.ore: numbers[2], .clay: numbers[3]],
                .geode: [.ore: numbers[4], .obsidian: numbers[5]]
            ]
        )
    }
}

private func canPurchase(robot: Mineral, costs: [Mineral: Int], state: State, maximums: [Mineral: Int]) -> Bool {
    for (mineral, price) in costs {
        if state.minerals[mineral]! < price {
            return false
        }
    }
    return state.robots[robot]! < maximums[robot]!
}

private func increment(robots: [Mineral: Int], minerals: [Mineral: Int]) -> [Mineral: Int] {
    var minerals = minerals
    for (robot, count) in robots {
        minerals[robot] = minerals[robot]! + count
    }
    return minerals
}

private func add(robot: Mineral, to robots: [Mineral: Int]) -> [Mineral: Int] {
    var robots = robots
    robots[robot] = robots[robot]! + 1
    return robots
}

private func buy(costs: [Mineral: Int], minerals: [Mineral: Int]) -> [Mineral: Int] {
    var minerals = minerals
    for (mineral, price) in costs {
        minerals[mineral] = minerals[mineral]! - price
    }
    return minerals
}

private func buy(state: State, robot: Mineral, costs: [Mineral: Int]) -> State {
    State(
        robots: add(robot: robot, to: state.robots),
        minerals: increment(robots: state.robots, minerals: buy(costs: costs, minerals: state.minerals))
    )
}

struct State: Hashable, Equatable, CustomStringConvertible {
    let robots: [Mineral: Int]
    let minerals: [Mineral: Int]

    var description: String {
        "Robots: \(robots), minerals: \(minerals)"
    }
}

@available(macOS 10.15, *)
func solve1(input: String) async -> Int {
    let blueprints = parse(input: input)
    let result = await withTaskGroup(of: Int.self) { taskGroup in
        for (index, blueprint) in blueprints.enumerated() {
            taskGroup.addTask {
                solve(blueprint: blueprint, maxTime: 24) * (index + 1)
            }
        }
        return await taskGroup.reduce(0, +)
    }
    return result
}

@available(macOS 10.15, *)
func solve2(input: String) async -> Int {
    let blueprints = parse(input: input).prefix(3)
    let result = await withTaskGroup(of: Int.self) { taskGroup in
        for blueprint in blueprints {
            taskGroup.addTask {
                solve(blueprint: blueprint, maxTime: 32)
            }
        }
        return await taskGroup.reduce(1, *)
    }
    return result
}

private func getMaxCost(in blueprint: Blueprint, for mineral: Mineral) -> Int {
    blueprint.prices.values.compactMap { $0[mineral] }.max()!
}

private func canBuyAnyMineral(state: State, maximums: [Mineral: Int]) -> Bool {
    let canBuyMaximumOre = state.minerals[.ore]! >= maximums[.ore]!
    let canBuyMaximumClay = state.robots[.clay]! == 0 || state.minerals[.clay]! >= maximums[.clay]!
    let canBuyMaximumObsidian = state.robots[.obsidian]! == 0 || state.minerals[.obsidian]! >= maximums[.obsidian]!
    return canBuyMaximumOre && canBuyMaximumClay && canBuyMaximumObsidian
}

private func canStillWin(with state: State, best: Int, timeRemaining: Int) -> Bool {
    let robotCount = state.robots[.geode]!
    let current = state.minerals[.geode]!
    let extraRobots = timeRemaining
    let expected = current + (robotCount + extraRobots) * timeRemaining
    return expected > best
}

func solve(blueprint: Blueprint, maxTime: Int) -> Int {
    var visited: Set<State> = []
    var rounds: [Set<State>] = [[
        .init(
            robots: [.ore: 1, .clay: 0, .geode: 0, .obsidian: 0],
            minerals: [.ore: 0, .clay: 0, .geode: 0, .obsidian: 0]
        )
    ]]
    let maximums: [Mineral: Int] = [
        .ore: getMaxCost(in: blueprint, for: .ore),
        .clay: getMaxCost(in: blueprint, for: .clay),
        .obsidian: getMaxCost(in: blueprint, for: .obsidian),
        .geode: Int.max
    ]
    var minute = 0
    var result = 0
    while minute < maxTime {
        let round = rounds.removeFirst()
        var nextRound: Set<State> = []
        for state in round where !visited.contains(state) {
            visited.insert(state)
            if !canStillWin(with: state, best: result, timeRemaining: maxTime - minute) {
                continue
            }
            if !canBuyAnyMineral(state: state, maximums: maximums) {
                nextRound.insert(
                    State(robots: state.robots, minerals: increment(robots: state.robots, minerals: state.minerals))
                )
            }
            for (robot, costs) in blueprint.prices {
                if canPurchase(robot: robot, costs: costs, state: state, maximums: maximums) {
                    let newState = buy(state: state, robot: robot, costs: costs)
                    result = max(result, newState.minerals[.geode]!)
                    nextRound.insert(newState)
                }
            }
        }
        rounds.append(nextRound)
        minute += 1
    }
    let round = rounds.removeFirst()
    result = round
        .max { $0.minerals[.geode]! < $1.minerals[.geode]! }!.minerals[.geode]!
    return result
}
