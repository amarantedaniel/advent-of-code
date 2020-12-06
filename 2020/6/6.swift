import Foundation

let input = try! String(contentsOfFile: "input.txt", encoding: .utf8)

let groups = input.components(separatedBy: "\n\n")

func countQuestionsWhereAnyoneSaidYes(groups: [String]) -> Int {
    return groups
        .map { $0.replacingOccurrences(of: "\n", with: "") }
        .map { Set($0).count }
        .reduce(0, +)
}

func countQuestionsWhereEveryoneSaidYes(groups: [String]) -> Int {
    return groups
        .map { $0.split(separator: "\n") }
        .map { countQuestionsWhereEveryoneSaidYes(group: $0) }
        .reduce(0, +)
}

func countQuestionsWhereEveryoneSaidYes(group: [String.SubSequence]) -> Int {
    let sets = group.map { Set($0) }
    return sets
        .reduce(into: sets.first!) { $0.formIntersection($1) }
        .count
}

// print(countQuestionsWhereAnyoneSaidYes(groups: groups))
print(countQuestionsWhereEveryoneSaidYes(groups: groups))
