import Foundation

enum Parser {
    static func parse(input: String) -> [Monkey] {
        input
            .components(separatedBy: "\n\n")
            .map { parseMonkey(input: $0) }
    }

    private static func parseMonkey(input: String) -> Monkey {
        let lines = input.split(separator: "\n")
        let id = Int(lines[0].split(separator: " ").last!.dropLast())!
        let items = lines[1]
            .components(separatedBy: ": ")
            .last!
            .components(separatedBy: ", ")
            .compactMap { Int($0) }
        let operation = parseOperation(
            input: lines[2]
                .components(separatedBy: "= ")
                .last!
        )
        let throwTo = parseThrow(input: Array(lines[3...]))
        return Monkey(
            id: id,
            items: items,
            operation: operation,
            throwTo: throwTo
        )
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

    private static func parseThrow(input: [Substring]) -> (Item) -> Int {
        let numbers = input.map { line in
            line
                .split(separator: " ")
                .compactMap { Int($0) }
                .last!
        }
        return { item in
            item % numbers[0] == 0 ? numbers[1] : numbers[2]
        }
    }
}
