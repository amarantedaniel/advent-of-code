import Foundation

typealias Template = String
typealias Rules = [String: Character]

extension String {
    func index(at i: Int) -> String.Index {
        return index(startIndex, offsetBy: i)
    }
}

extension Dictionary where Value == Int {
    mutating func increment(at index: Key) {
        self[index] = (self[index] ?? 0) + 1
    }
}

enum Parser {
    static func parse(input: String) -> (Template, Rules) {
        let components = input.components(separatedBy: "\n\n")
        let template = components[0]
        let rules = components[1]
            .split(separator: "\n")
            .map { $0.components(separatedBy: " -> ") }
            .reduce(into: Rules(), { rules, ruleComponents in
                rules[ruleComponents[0]] = Character(ruleComponents[1])
            })
        return (template, rules)
    }
}

func execute(template: Template, rules: Rules) -> Template {
    var template = template
    var i = 1
    while i < template.count {
        let secondIndex = template.index(at: i)
        let firstIndex = template.index(before: secondIndex)
        let pair = String(template[firstIndex...secondIndex])
        if let character = rules[pair] {
            template.insert(character, at: secondIndex)
            i += 1
        }
        i += 1
    }
    return template
}

func countCharacters(in template: Template) -> [Character: Int] {
    template.reduce(into: [Character: Int]()) { map, character in
        map.increment(at: character)
    }
}

func solve1(input: String) -> Int {
    let (template, rules) = Parser.parse(input: input)
    let result = (1...10).reduce(template) { template, _ in
        execute(template: template, rules: rules)
    }
    let map = countCharacters(in: result)
        .sorted { $0.value < $1.value }
    return map.last!.value - map.first!.value
}
