import Foundation

func countAnswers(groups: [String], groupReducer: (inout Set<Character>, Set<Character>) -> Void) -> Int {
    return groups
        .map { $0.split(separator: "\n") }
        .map { reduceGroup(group: $0, reducer: groupReducer) }
        .reduce(0, +)
}

func reduceGroup(group: [Substring], reducer: (inout Set<Character>, Set<Character>) -> Void) -> Int {
    let sets = group.map(Set.init)
    return sets.reduce(into: sets.first!, reducer).count
}

let input = try! String(contentsOfFile: "input.txt", encoding: .utf8)
let groups = input.components(separatedBy: "\n\n")

print(countAnswers(groups: groups) { $0.formUnion($1) })
print(countAnswers(groups: groups) { $0.formIntersection($1) })
