import Foundation

typealias Template = [String: Int]
typealias Rules = [String: Character]

extension Dictionary where Value == Int {
    mutating func increment(at index: Key, amount: Int = 1) {
        self[index] = (self[index] ?? 0) + amount
    }
}

enum Parser {
    static func parse(input: String) -> (Template, Rules) {
        let components = input.components(separatedBy: "\n\n")
        return (parseTemplate(input: components[0]), parseRules(input: components[1]))
    }

    private static func parseTemplate(input: String) -> Template {
        return (1..<input.count).reduce(into: Template()) { template, i in
            let secondIndex = input.index(input.startIndex, offsetBy: i)
            let firstIndex = input.index(before: secondIndex)
            let pair = String(input[firstIndex...secondIndex])
            template.increment(at: pair)
        }
    }

    private static func parseRules(input: String) -> Rules {
        return input
            .split(separator: "\n")
            .map { $0.components(separatedBy: " -> ") }
            .reduce(into: Rules()) { rules, ruleComponents in
                rules[ruleComponents[0]] = Character(ruleComponents[1])
            }
    }
}

func execute(template: Template, rules: Rules) -> Template {
    var newTemplate = Template()
    for (key, value) in template {
        if let character = rules[key] {
            newTemplate.increment(at: "\(key.first!)\(character)", amount: value)
            newTemplate.increment(at: "\(character)\(key.last!)", amount: value)
        } else {
            newTemplate.increment(at: key, amount: value)
        }
    }
    return newTemplate
}

func countCharacters(template: [String: Int]) -> [Character: Int] {
    return template.reduce(into: [Character: Int]()) { dict, tuple in
        dict.increment(at: tuple.key.first!, amount: tuple.value)
        dict.increment(at: tuple.key.last!, amount: tuple.value)
    }.reduce(into: [Character: Int]()) { dict, tuple in
        dict[tuple.key] = tuple.value / 2 + tuple.value % 2
    }
}

func solve(input: String, iterations: Int) -> Int {
    let (template, rules) = Parser.parse(input: input)
    let result = (1...iterations).reduce(template) { template, _ in
        execute(template: template, rules: rules)
    }

    let characters = countCharacters(template: result)
        .sorted { $0.value < $1.value }

    return characters.last!.value - characters.first!.value
}

func solve1(input: String) -> Int {
    return solve(input: input, iterations: 10)
}

func solve2(input: String) -> Int {
    return solve(input: input, iterations: 40)
}
