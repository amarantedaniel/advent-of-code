func validIndexesForRule(rule: Rule, rules: [Rule], tickets: [Ticket]) -> [Int] {
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

public func solve2(_ input: String) -> Int {
    var (rules, ticket, tickets) = Parser.parse(input: input)
    let validTickets = tickets.filter { isValid(ticket: $0, rules: rules) }

    for i in 0 ..< rules.count {
        rules[i].validIndexes = validIndexesForRule(rule: rules[i], rules: rules, tickets: validTickets)
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

    return result
}
