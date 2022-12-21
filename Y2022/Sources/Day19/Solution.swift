import Foundation

enum Mineral {
    case ore
    case clay
    case obsidian
    case geode
}

struct Cost {
    let mineral: Mineral
    let value: Int
}

struct Robot: Hashable {
    let mineral: Mineral
}

struct Blueprint {
    let prices: [Robot: [Cost]]
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
                Robot(mineral: .ore): [Cost(mineral: .ore, value: numbers[0])],
                Robot(mineral: .clay): [Cost(mineral: .ore, value: numbers[1])],
                Robot(mineral: .obsidian): [Cost(mineral: .ore, value: numbers[2]), Cost(mineral: .clay, value: numbers[3])],
                Robot(mineral: .geode): [Cost(mineral: .ore, value: numbers[4]), Cost(mineral: .clay, value: numbers[5])]
            ]
        )
    }
}

private func execute(blueprint: Blueprint, robots: [Robot]) {
    var minerals: [Mineral: Int] = [:]

    // build
    for (robot, costs) in blueprint.prices {

    }

    // mine
    for robot in robots {
        minerals.increment(at: robot.mineral)
    }
}

func solve1(input: String) -> Int {
    let blueprints = parse(input: input)
    execute(blueprint: blueprints[0], robots: [.init(mineral: .ore)])
    return 0
}

func solve2(input: String) -> Int {
    0
}

extension Dictionary where Value == Int {
    mutating func increment(at index: Key, amount: Int = 1) {
        self[index] = (self[index] ?? 0) + amount
    }
}
