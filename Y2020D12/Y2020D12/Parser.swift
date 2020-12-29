enum Parser {
    static func parse(input: String) -> [Action] {
        input.split(separator: "\n").compactMap(parseAction(input:))
    }

    private static func parseAction(input: Substring) -> Action? {
        switch (input.first, Int(input.dropFirst())) {
        case let ("N", value?):
            return .north(value)
        case let ("S", value?):
            return .south(value)
        case let ("E", value?):
            return .east(value)
        case let ("W", value?):
            return .west(value)
        case let ("R", value?):
            return .right(value)
        case let ("L", value?):
            return .left(value)
        case let ("F", value?):
            return .forward(value)
        default:
            return nil
        }
    }
}
