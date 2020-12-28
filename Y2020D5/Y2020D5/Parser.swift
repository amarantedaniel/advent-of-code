enum Parser {
    static func parse(input: String) -> [[Move]] {
        input
            .split(separator: "\n")
            .map { $0.compactMap(Move.init(rawValue:)) }
    }
}
