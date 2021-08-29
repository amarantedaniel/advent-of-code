enum Parser {
    static func parse(input: String) -> ([Rule], Ticket, [Ticket]) {
        let components = input.components(separatedBy: "\n\n")
        let rules = parseRules(input: components[0])
        let ticket = parseTicket(input: components[1])
        let tickets = parseNearbyTickets(input: components[2])
        return (rules, ticket, tickets)
    }

    private static func parseRules(input: String) -> [Rule] {
        input.split(separator: "\n").map(parseRule(input:))
    }

    private static func parseRule(input: Substring) -> Rule {
        let elements = input.components(separatedBy: ": ")
        let name = String(elements[0])
        let ranges = elements[1].components(separatedBy: " or ").map(parseRange(input:))
        return Rule(name: name, ranges: ranges)
    }

    private static func parseRange(input: String) -> Range {
        let numbers = input.split(separator: "-")
        return Range(from: Int(numbers[0])!, to: Int(numbers[1])!)
    }

    private static func parseTicket(input: String) -> Ticket {
        input
            .split(separator: "\n")
            .dropFirst()
            .map { $0.split(separator: ",").compactMap { Int($0) }}
            .first!
    }

    private static func parseNearbyTickets(input: String) -> [Ticket] {
        input
            .split(separator: "\n")
            .dropFirst()
            .map { $0.split(separator: ",").compactMap { Int($0) } }
    }
}
