import AdventOfCode
import Foundation

enum Register {
    case a, b, c
}

enum Output {
    case none
    case value(Int)
    case jump(Int)
}

enum ComboOperand {
    case literal(Int)
    case register(Register)

    init(value: Int) {
        switch value {
        case 0...3:
            self = .literal(value)
        case 4:
            self = .register(.a)
        case 5:
            self = .register(.b)
        case 6:
            self = .register(.c)
        default:
            fatalError()
        }
    }
}

enum Instruction: Int {
    case adv, bxl, bst, jnz, bxc, out, bdv, cdv
}

struct Operation {
    let instruction: Instruction
    let operand: Int
}

enum Parser {
    static func parseRawProgram(input: String) -> [Int] {
        let lines = input.split(separator: "\n")
        return lines[3]
            .split(separator: ":")[1]
            .split(separator: ",")
            .compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
    }

    static func parse(input: String) -> ([Register: Int], [Operation]) {
        let lines = input.split(separator: "\n")
        let registers: [Register: Int] = [
            .a: Int(lines[0].split(separator: ":")[1].trimmingCharacters(in: .whitespaces))!,
            .b: Int(lines[1].split(separator: ":")[1].trimmingCharacters(in: .whitespaces))!,
            .c: Int(lines[2].split(separator: ":")[1].trimmingCharacters(in: .whitespaces))!
        ]
        let numbers = lines[3]
            .split(separator: ":")[1]
            .split(separator: ",")
            .compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
        let operations = stride(from: 0, to: numbers.count, by: 2).map { i in
            Operation(instruction: Instruction(rawValue: numbers[i])!, operand: numbers[i + 1])
        }
        return (registers, operations)
    }
}

struct Day17: AdventDay {
    private func execute(registers: inout [Register: Int], operation: Operation) -> Output {
        switch (operation.instruction, operation.operand) {
        case let (.adv, value):
            switch ComboOperand(value: value) {
            case let .literal(value):
                registers[.a] = registers[.a]! >> value
            case let .register(value):
                registers[.a] = registers[.a]! >> registers[value]!
            }
        case let (.bxl, value):
            registers[.b] = registers[.b]! ^ value
        case let (.bst, value):
            switch ComboOperand(value: value) {
            case let .literal(value):
                registers[.b] = value % 8
            case let .register(value):
                registers[.b] = registers[value]! % 8
            }
        case let (.jnz, value):
            guard registers[.a] != 0 else { break }
            return .jump(value / 2)
        case (.bxc, _):
            registers[.b] = registers[.b]! ^ registers[.c]!
        case let (.out, value):
            switch ComboOperand(value: value) {
            case let .literal(value):
                return .value(value % 8)
            case let .register(value):
                return .value(registers[value]! % 8)
            }
        case let (.bdv, value):
            switch ComboOperand(value: value) {
            case let .literal(value):
                registers[.b] = registers[.a]! >> value
            case let .register(value):
                registers[.b] = registers[.a]! >> registers[value]!
            }
        case let (.cdv, value):
            switch ComboOperand(value: value) {
            case let .literal(value):
                registers[.c] = registers[.a]! >> value
            case let .register(value):
                registers[.c] = registers[.a]! >> registers[value]!
            }
        }
        return .none
    }

    private func solve(operations: [Operation], registers: inout [Register: Int]) -> [Int] {
        var output: [Int] = []
        var index = 0
        while index < operations.count {
            switch execute(registers: &registers, operation: operations[index]) {
            case .none:
                index += 1
            case let .value(value):
                output.append(value)
                index += 1
            case let .jump(value):
                index = Int(value)
            }
        }
        return output
    }

    private func solve(registers: inout [Register: Int]) -> [Int] {
        var result: [Int] = []
        repeat {
            registers[.b] = registers[.a]! % 8
            registers[.b] = registers[.b]! ^ 2
            registers[.c] = registers[.a]! >> registers[.b]!
            registers[.b] = registers[.b]! ^ registers[.c]!
            registers[.b] = registers[.b]! ^ 7
            registers[.a] = registers[.a]! >> 3
            result.append(registers[.b]! % 8)
        } while registers[.a]! != 0
        return result
    }

    func part1(input: String) throws -> String {
        var (registers, operations) = Parser.parse(input: input)
        return solve(operations: operations, registers: &registers)
            .compactMap(\.description)
            .joined(separator: ",")
    }

    func solve(partial: Int, output: [Int]) -> Int? {
        var registers: [Register: Int] = [:]
        for i in 0..<8 {
            registers = [.a: partial << 3 + i, .b: 0, .c: 0]
            let solution = solve(registers: &registers)
            if solution == output.suffix(solution.count) {
                if solution.count == output.count {
                    return partial << 3 + i
                }
                if let solution = solve(partial: partial << 3 + i, output: output) {
                    return solution
                }
            }
        }
        return nil
    }

    func part2(input: String) throws -> String {
        let output = Parser.parseRawProgram(input: input)
        return "\(solve(partial: 0, output: output)!)"
    }
}
