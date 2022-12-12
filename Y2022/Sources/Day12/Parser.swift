import Foundation

enum Parser {
    static func parse(input: String) -> [[Node]] {
        input.split(separator: "\n").reduce(into: []) { matrix, line in
            matrix.append(
                Array(line).map { character in
                    Node(character: character, value: value(from: character))
                }
            )
        }
    }

    private static func value(from character: Character) -> Int {
        switch character {
        case "S":
            return Int(Character("a").asciiValue!)
        case "E":
            return Int(Character("z").asciiValue!)
        default:
            return Int(character.asciiValue!)
        }
    }
}
