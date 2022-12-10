import Foundation

enum Instruction {
    case noop
    case addx(Int)
}

func parse(input: String) -> [Instruction] {
    input.split(separator: "\n").map { line in
        if line == "noop" {
            return .noop
        } else {
            let number = Int(line.split(separator: " ").last!)!
            return .addx(number)
        }
    }
}

struct Cycle {
    let current: Int
    let register: Int
}

struct Program {
    let instructions: [Instruction]
    var cycle = 0
    var register = 1

    mutating func execute(onCycle: (Cycle) -> Void) {
        for instruction in instructions {
            switch instruction {
            case .noop:
                cycle += 1
                onCycle(Cycle(current: cycle, register: register))
            case .addx(let value):
                cycle += 1
                onCycle(Cycle(current: cycle, register: register))
                cycle += 1
                onCycle(Cycle(current: cycle, register: register))
                register += value
            }
        }
    }
}

func solve1(input: String) -> Int {
    let instructions = parse(input: input)
    var program = Program(instructions: instructions)
    let cycles = [20, 60, 100, 140, 180, 220]
    var result = 0
    program.execute { cycle in
        if cycles.contains(cycle.current) {
            result += cycle.register * cycle.current
        }
    }
    return result
}

func solve2(input: String) -> String {
    let instructions = parse(input: input)
    var program = Program(instructions: instructions)
    var result = ""
    program.execute { cycle in
        let sprite = (cycle.register - 1) ... (cycle.register + 1)
        let position = (cycle.current - 1) % 40
        if position == 0 {
            result.append("\n")
        }
        result += sprite.contains(position) ? "#" : "."
    }
    return result.trimmingCharacters(in: .whitespacesAndNewlines)
}
