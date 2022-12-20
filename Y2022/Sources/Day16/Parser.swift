import Foundation

enum Parser {
    static func parse(input: String) -> [Valve] {
        let pattern = """
        Valve ([A-Z]+) has flow rate=([0-9]+); tunnel(?:s*) lead(?:s*) to valve(?:s*) ([A-Z]+(?:, [A-Z]+)*)
        """
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(input.startIndex..., in: input)
        let matches = regex.matches(in: input, range: range)
        return matches.map { match in
            let substrings = (1 ..< match.numberOfRanges).map { index in
                input[Range(match.range(at: index), in: input)!]
            }
            return Valve(
                id: String(substrings[0]),
                flow: Int(substrings[1])!,
                next: substrings[2].components(separatedBy: ", ")
            )
        }
    }
}
