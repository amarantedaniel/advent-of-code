import Foundation

typealias Password = String

struct Policy {
    let letter: Character
    let restrictions: [Int]

    func validateMinMax(password: String) -> Bool {
        let min = restrictions[0]
        let max = restrictions[1]
        var count = 0
        for character in password where character == letter {
            count += 1
        }
        return count >= min && count <= max
    }

    func validatePositions(password: String) -> Bool {
        var count = 0
        for restriction in restrictions {
            let index = password.index(password.startIndex, offsetBy: restriction - 1)
            if password[index] == letter {
                count += 1
            }
        }
        return count == 1
    }
}

func parseLine(line: String.SubSequence) -> (Password, Policy) {
    let elements = line.split(separator: " ")
    let restrictions = elements[0].split(separator: "-").compactMap { Int($0) }
    let letter = elements[1].first!
    return (String(elements[2]), Policy(letter: letter, restrictions: restrictions))
}

func parseInput(input: String) -> [(Password, Policy)] {
    input.split(separator: "\n").map(parseLine)
}

let input = try! String(contentsOfFile: "input.txt", encoding: .utf8)
let result = parseInput(input: input)
    .filter { password, policy in policy.validatePositions(password: password) }
    .count
print(result)
