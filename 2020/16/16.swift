import Foundation

typealias Ticket = [Int]

struct Parser {
    func parse(input: String) -> ([Rule], Ticket, [Ticket]) {
        let components = input.components(separatedBy: "\n\n")
        let rules = parseRules(input: components[0])
        let ticket = parseTicket(input: components[1])
        let tickets = parseNearbyTickets(input: components[2])
        return (rules, ticket, tickets)
    }

    private func parseRules(input: String) -> [Rule] {
        input.split(separator: "\n").map(Rule.init(input:))
    }

    private func parseTicket(input: String) -> Ticket {
        input
            .split(separator: "\n")
            .dropFirst()
            .map { $0.split(separator: ",").compactMap { Int($0) }}
            .first!
    }

    private func parseNearbyTickets(input: String) -> [Ticket] {
        input
            .split(separator: "\n")
            .dropFirst()
            .map { $0.split(separator: ",").compactMap { Int($0) } }
    }
}

struct Range {
    let from: Int
    let to: Int

    init(input: String) {
        let numbers = input.split(separator: "-")
        from = Int(numbers[0])!
        to = Int(numbers[1])!
    }

    func contains(number: Int) -> Bool {
        number >= from && number <= to
    }
}

struct Rule {
    let name: String
    let ranges: [Range]
    var validIndexes: [Int] = []

    init(input: Substring) {
        let elements = input.components(separatedBy: ": ")
        name = String(elements[0])
        ranges = elements[1].components(separatedBy: " or ").map(Range.init(input:))
    }

    func isValid(value: Int) -> Bool {
        ranges.contains { $0.contains(number: value) }
    }
}

let input = try! String(contentsOfFile: "input.txt", encoding: .utf8)

var (rules, ticket, tickets) = Parser().parse(input: input)

func validIndexesForRule(rule: Rule, tickets: [Ticket]) -> [Int] {
    var result: [Int] = []
    let count = rules.count
    for i in 0 ..< count {
        let numbers = tickets.map { $0[i] }
        let valid = numbers.filter { rule.isValid(value: $0) }
        if numbers.count == valid.count {
            result.append(i)
        }
    }
    return result
}

func isValid(ticket: Ticket, rules: [Rule]) -> Bool {
    let ranges = rules.flatMap(\.ranges)
    return ticket.allSatisfy { number in
        ranges.contains { range in range.contains(number: number) }
    }
}

let validTickets = tickets.filter { isValid(ticket: $0, rules: rules) }

for i in 0 ..< rules.count {
    rules[i].validIndexes = validIndexesForRule(rule: rules[i], tickets: validTickets)
}

var completed: Set<Int> = []
while completed.count != rules.count {
    for i in 0 ..< rules.count {
        if rules[i].validIndexes.count == 1 {
            completed.formUnion(rules[i].validIndexes)
        } else {
            rules[i].validIndexes.removeAll { completed.contains($0) }
        }
    }
}

let result = rules
    .filter { $0.name.hasPrefix("departure") }
    .flatMap(\.validIndexes)
    .map { ticket[$0] }
    .reduce(1, *)

print(result)
