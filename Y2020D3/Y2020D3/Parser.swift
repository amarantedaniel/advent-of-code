enum Parser {
    static func parse(input: String) -> Mountain {
        return input.split(separator: "\n").map {
            $0.compactMap(Square.init(rawValue:))
        }
    }
}
