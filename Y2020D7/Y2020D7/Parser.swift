enum Parser {
    static func parse(input: String) -> [(String, [String: Int])] {
        input.split(separator: "\n").map(parseRule(input:))
    }

    private static func parseRule(input: Substring) -> (String, [String: Int]) {
        let info = input.components(separatedBy: " bags contain ")
        let bag = info[0]
        let innerBags = info[1]
            .components(separatedBy: ", ")
            .reduce(into: [String: Int]()) { dict, data in
                let values = data.split(separator: " ")
                if let number = Int(values[0]) {
                    let name = values[1 ... 2].joined(separator: " ")
                    dict[name] = number
                }
            }
        return (bag, innerBags)
    }
}
