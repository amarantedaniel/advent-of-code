func countBagsThatCanHold(bag: String, bags: [(String, [String: Int])]) -> Int {
    var remainingBags = [bag]
    var result: Set<String> = []

    while !remainingBags.isEmpty {
        let bag = remainingBags.removeFirst()
        bags
            .filter { _, dictionary in dictionary[bag] != nil }
            .map { name, _ in name }
            .forEach {
                if !result.contains($0) {
                    remainingBags.append($0)
                }
                result.insert($0)
            }
    }
    return result.count
}

public func solve1(_ input: String) -> Int? {
    let bags = Parser.parse(input: input)
    return countBagsThatCanHold(bag: "shiny gold", bags: bags)
}

public func solve2(_ input: String) -> Int? {
    let input = Parser.parse(input: input)
    let graph = GraphBuilder.buildBagGraph(input: input, startingPoint: "shiny gold")
    return graph.countInnerBags()
}
