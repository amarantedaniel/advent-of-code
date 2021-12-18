enum Parser {
    static func parse(input: String) -> [(Password, Policy)] {
        input.split(separator: "\n").map(parseLine(line:))
    }

    private static func parseLine(line: Substring) -> (Password, Policy) {
        let elements = line.split(separator: " ")
        let restrictions = elements[0].split(separator: "-").compactMap { Int($0) }
        let letter = elements[1].first!
        return (String(elements[2]), Policy(letter: letter, restrictions: restrictions))
    }
}
