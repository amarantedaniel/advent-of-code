import Foundation

let score: [Character: Int] = [")": 3, "]": 57, "}": 1197, ">": 25137]
let matching: [Character: Character] = [")": "(", "]": "[", "}": "{", ">": "<"]

func analyze(chunk: Substring) -> Int {
    var stack: [Character] = []

    for character in chunk {
        switch character {
        case "[", "{", "<", "(":
            stack.append(character)
        case "]", "}", ">", ")":
            if stack.popLast() != matching[character] {
                return score[character] ?? 0
            }
        default:
            break
        }
    }
    return 0
}

func solve1(input: String) -> Int {
    input.split(separator: "\n").reduce(0) { sum, chunk in
        sum + analyze(chunk: chunk)
    }
}

func solve2(input: String) -> Int {
    return 0
}
