import AdventOfCode
import Foundation

struct Memory {
    var registers: [Register: Int]
}

enum Register {
    case a, b, c
}

enum Operand {
    case literal(Int)
    case register(Register)
}

enum Instruction: Int {
    case adv = 0
    case bxl
    case bst
    case jnz
    case bxc
    case out
    case bdv
    case cdv
}

struct Operation {
    let instruction: Instruction
    let operand: Operand
}

enum Parser {
    static func parse(input: String) -> (Memory, [Operation]) {
        let lines = input.split(separator: "\n")
        let memory = Memory(
            registers: [
                .a: Int(lines[0].split(separator: ":")[1].trimmingCharacters(in: .whitespaces))!,
                .b: Int(lines[1].split(separator: ":")[1].trimmingCharacters(in: .whitespaces))!,
                .c: Int(lines[2].split(separator: ":")[1].trimmingCharacters(in: .whitespaces))!
            ]
        )
        var operations: [Operation] = []
        let numbers = lines[3]
            .split(separator: ":")[1]
            .split(separator: ",")
            .compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
        var isInstruction = true
        var instruction: Instruction!
        for number in numbers {
            defer { isInstruction.toggle() }
            if isInstruction {
                instruction = Instruction(rawValue: number)!
            } else {
                switch number {
                case 0...3:
                    operations.append(
                        Operation(instruction: instruction, operand: .literal(number))
                    )
                case 4:
                    operations.append(
                        Operation(instruction: instruction, operand: .register(.a))
                    )
                case 5:
                    operations.append(
                        Operation(instruction: instruction, operand: .register(.b))
                    )
                case 6:
                    operations.append(
                        Operation(instruction: instruction, operand: .register(.c))
                    )
                default:
                    fatalError()
                }
            }
        }
        return (memory, operations)
    }
}

struct Day17: AdventDay {
    private func execute(memory: inout Memory, operation: Operation) -> Int? {
        print(operation)
        switch (operation.instruction, operation.operand) {
        case (.adv, .literal(let value)):
            let numerator = memory.registers[.a]!
            let denominator = Int(powl(2, Double(value)))
            memory.registers[.a] = numerator / denominator
        case (.adv, .register(let register)):
            let numerator = memory.registers[.a]!
            let denominator = Int(powl(2, Double(memory.registers[register]!)))
            memory.registers[.a] = numerator / denominator
        case (.bxl, _):
            fatalError()
        case (.bst, .register(let register)):
            memory.registers[.b] = memory.registers[register]! % 8
        case (.bst, .literal(let value)):
            memory.registers[.b] = value % 8
        case (.jnz, _):
            fatalError()
        case (.bxc, _):
            fatalError()
        case (.out, .register(let register)):
            return memory.registers[register]! % 8
        case (.out, .literal(let value)):
            return value % 8
        case (.bdv, _):
            fatalError()
        case (.cdv, _):
            fatalError()
        }
        return nil
    }

    func part1(input: String) throws -> String {
        var (memory, operations) = Parser.parse(input: input)
        var output: [Int] = []
        for operation in operations {
            if let value = execute(memory: &memory, operation: operation) {
                output.append(value)
            }
        }
        return output.compactMap(\.description).joined(separator: ",")
    }

    func part2(input: String) throws -> String {
        throw AdventError.notImplemented
    }
}
