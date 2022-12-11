import Foundation

enum Parser {
    static func parse(input: String) -> [Monkey] {
        let pattern = """
        Monkey ([0-9]):
          Starting items: ([0-9]+(?:, [0-9]+)*)
          Operation: new = (old [\\+\\*] (?:[0-9]+|old))
          Test: divisible by ([0-9]+)
            If true: throw to monkey ([0-9])
            If false: throw to monkey ([0-9])
        """
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(input.startIndex..., in: input)
        let matches = regex.matches(in: input, range: range)
        return matches.map { match in
            let substrings = (1 ..< match.numberOfRanges).map { index in
                input[Range(match.range(at: index), in: input)!]
            }
            return Monkey(
                id: Int(substrings[0])!,
                items: substrings[1].components(separatedBy: ", ").compactMap { Int($0) },
                operation: parseOperation(input: String(substrings[2])),
                throwTo: { item in
                    item % Int(substrings[3])! == 0 ? Int(substrings[4])! : Int(substrings[5])!
                }
            )
        }
    }

    private static func parseOperation(input: String) -> (Item) -> Item {
        let elements = input.split(separator: " ")
        switch elements[1] {
        case "+":
            return { item in
                let first = elements[0] == "old" ? item : Int(elements[0])!
                let second = elements[2] == "old" ? item : Int(elements[2])!
                return first + second
            }
        case "*":
            return { item in
                let first = elements[0] == "old" ? item : Int(elements[0])!
                let second = elements[2] == "old" ? item : Int(elements[2])!
                return first * second
            }
        default:
            fatalError()
        }
    }
}
