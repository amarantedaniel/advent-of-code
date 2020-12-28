typealias Group = [Substring]
typealias Reducer = (inout Set<Character>, Set<Character>) -> Void

func countAnswers(groups: [Group], groupReducer: Reducer) -> Int {
    groups
        .map { reduceGroup(group: $0, reducer: groupReducer) }
        .reduce(0, +)
}

func reduceGroup(group: Group, reducer: Reducer) -> Int {
    let sets = group.map(Set.init)
    return sets.reduce(into: sets.first!, reducer).count
}

func parseGroups(input: String) -> [Group] {
    return input
        .components(separatedBy: "\n\n")
        .map { $0.split(separator: "\n") }
}

public func solve1(_ input: String) -> Int {
    let groups = parseGroups(input: input)
    return countAnswers(groups: groups) { $0.formUnion($1) }
}

public func solve2(_ input: String) -> Int {
    let groups = parseGroups(input: input)
    return countAnswers(groups: groups) { $0.formIntersection($1) }
}
