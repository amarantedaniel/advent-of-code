enum Parser {
    static func parse(input: String) -> [Operation] {
        input.split(separator: "\n").compactMap(Operation.init(text:))
    }
}
