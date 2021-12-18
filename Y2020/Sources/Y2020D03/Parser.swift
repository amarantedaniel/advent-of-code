enum Parser {
    static func parse(input: String) -> Mountain {
        input.split(separator: "\n").map {
            $0.compactMap(Square.init(rawValue:))
        }
    }
}
