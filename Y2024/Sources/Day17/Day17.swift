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
                let numerator = registers[.a]!
                let denominator = Int(powl(2, Double(value)))
                registers[.a] = numerator / denominator
            case let .register(value):
                let numerator = registers[.a]!
                let denominator = Int(powl(2, Double(registers[value]!)))
                registers[.a] = numerator / denominator
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
                let numerator = registers[.a]!
                let denominator = Int(powl(2, Double(value)))
                registers[.b] = numerator / denominator
            case let .register(value):
                let numerator = registers[.a]!
                let denominator = Int(powl(2, Double(registers[value]!)))
                registers[.b] = numerator / denominator
            }
        case let (.cdv, value):
            switch ComboOperand(value: value) {
            case let .literal(value):
                let numerator = registers[.a]!
                let denominator = Int(powl(2, Double(value)))
                registers[.c] = numerator / denominator
            case let .register(value):
                let numerator = registers[.a]!
                let denominator = Int(powl(2, Double(registers[value]!)))
                registers[.c] = numerator / denominator
            }
        }
        return .none
    }

    func part1(input: String) throws -> String {
        var (registers, operations) = Parser.parse(input: input)
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
                index = value
            }
        }
        return output.compactMap(\.description).joined(separator: ",")
    }

    func part2(input: String) throws -> String {
        throw AdventError.notImplemented
    }
}
