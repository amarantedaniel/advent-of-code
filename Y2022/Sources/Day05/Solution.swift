import Foundation

struct Instrution {
    let count: Int
    let from: Int
    let to: Int
}

private func parse(input: String) -> ([Instrution], [[Character]]) {
    let comp = input.components(separatedBy: "\n\n")
    let stacks = parseStacks(input: comp[0])
    let instructions = parseInstructions(input: comp[1])
    return (instructions, stacks)
}

private func parseStacks(input: String) -> [[Character]] {
    let lines = input.split(separator: "\n").dropLast(1).map { Array($0) }
    var stacks: [[Character]] = []
    for line in lines {
        for i in stride(from: 1, to: line.count, by: 4) {
            let index = i / 4
            let character = line[i]
            if stacks.count == index {
                stacks.append([])
            }
            if !character.isWhitespace {
                stacks[index].insert(character, at: 0)
            }
        }
    }
    return stacks
}

private func parseInstructions(input: String) -> [Instrution] {
    let lines = input.split(separator: "\n")
    return lines.map { line in
        let numbers = line.split(separator: " ")
            .compactMap { Int($0) }
        return Instrution(
            count: numbers[0],
            from: numbers[1] - 1,
            to: numbers[2] - 1
        )
    }
}

func solve1(input: String) -> String {
    var (instructions, stacks) = parse(input: input)
    for instruction in instructions {
        let stack = stacks[instruction.from]
        let remaining = stack.dropLast(instruction.count)
        let removed = stack.suffix(instruction.count)
        stacks[instruction.from] = Array(remaining)
        stacks[instruction.to].append(contentsOf: removed.reversed())
    }
    return stacks.reduce("") { $0 + String($1.last!) }
}

func solve2(input: String) -> String {
    var (instructions, stacks) = parse(input: input)
    for instruction in instructions {
        let stack = stacks[instruction.from]
        let remaining = stack.dropLast(instruction.count)
        let removed = stack.suffix(instruction.count)
        stacks[instruction.from] = Array(remaining)
        stacks[instruction.to].append(contentsOf: removed)
    }
    return stacks.reduce("") { $0 + String($1.last!) }
}
