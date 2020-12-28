enum Parser {
    static func parse(input: String) -> [Passport] {
        input
            .components(separatedBy: "\n\n")
            .map { $0.split(separator: "\n").flatMap { $0.split(separator: " ") } }
            .map(parsePassport(input:))
    }

    private static func parsePassport(input: [Substring]) -> Passport {
        let dictionary = input.reduce(into: [String: String]()) { dict, entry in
            let keyValue = entry.split(separator: ":")
            dict[String(keyValue[0])] = String(keyValue[1])
        }
        return Passport(input: dictionary)
    }
}
