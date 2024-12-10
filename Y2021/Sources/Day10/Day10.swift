import AdventOfCode

import Foundation

enum SyntaxError {
    case wrongCharacter(character: Character)
    case missingCharacter(stack: [Character])

    var isWrongCharacterError: Bool {
        if case .wrongCharacter = self { return true }
        return false
    }

    var isMissingCharacterError: Bool {
        if case .missingCharacter = self { return true }
        return false
    }
}

struct Day10: AdventDay {
    func analyze(chunk: Substring) -> SyntaxError? {
        let openingEquivalent: [Character: Character] = [
            ")": "(", "]": "[", "}": "{", ">": "<"
        ]
        var stack: [Character] = []

        for character in chunk {
            switch character {
            case "[", "{", "<", "(":
                stack.append(character)
            case "]", "}", ">", ")":
                if stack.popLast() != openingEquivalent[character] {
                    return .wrongCharacter(character: character)
                }
            default:
                break
            }
        }
        if !stack.isEmpty {
            return .missingCharacter(stack: stack)
        }
        return nil
    }

    func calculateScore(error: SyntaxError) -> Int {
        switch error {
        case let .wrongCharacter(character):
            let scoreMap: [Character: Int] = [")": 3, "]": 57, "}": 1_197, ">": 25_137]
            return scoreMap[character]!
        case let .missingCharacter(stack):
            let scoreMap: [Character: Int] = ["(": 1, "[": 2, "{": 3, "<": 4]
            return stack.reversed().reduce(0) { score, character in
                (score * 5) + scoreMap[character]!
            }
        }
    }

    func part1(input: String) -> Int {
        return input.split(separator: "\n")
            .compactMap { chunk in analyze(chunk: chunk) }
            .filter(\.isWrongCharacterError)
            .reduce(0) { sum, error in
                sum + calculateScore(error: error)
            }
    }

    func part2(input: String) -> Int {
        let results = input.split(separator: "\n")
            .compactMap { chunk in analyze(chunk: chunk) }
            .filter(\.isMissingCharacterError)
            .map { error in calculateScore(error: error) }
        return results.sorted()[results.count / 2]
    }
}
