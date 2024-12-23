import AdventOfCode
import Foundation

enum Operation {
    case number(Int)
    case sum(String, String)
    case sub(String, String)
    case mul(String, String)
    case div(String, String)
    case input

    var elements: (String, String) {
        switch self {
        case .number, .input:
            fatalError()
        case let .sum(lhs, rhs):
            return (lhs, rhs)
        case let .sub(lhs, rhs):
            return (lhs, rhs)
        case let .mul(lhs, rhs):
            return (lhs, rhs)
        case let .div(lhs, rhs):
            return (lhs, rhs)
        }
    }
}

struct IsInput: Error {}

struct Day21: AdventDay {
    func part1(input: String) -> Int {
        let operations = parse(input: input)
        return try! calculate(current: "root", operations: operations)
    }

    func part2(input: String) -> Int {
        var operations = parse(input: input)
        operations["humn"] = .input
        let (lhs, rhs) = operations["root"]!.elements

        if let result = try? calculate(current: lhs, operations: operations) {
            return calculate(current: rhs, operations: operations, mustEqual: result)
        }
        let result = try! calculate(current: rhs, operations: operations)
        return calculate(current: lhs, operations: operations, mustEqual: result)
    }

    func parse(input: String) -> [String: Operation] {
        let lines = input.split(separator: "\n")
        var result: [String: Operation] = [:]
        for line in lines {
            let components = line.split(separator: ":")
            let id = String(components[0])
            if let number = Int(components[1].trimmingCharacters(in: .whitespacesAndNewlines)) {
                result[id] = .number(number)
                continue
            }
            let operation = components[1].split(separator: " ")
            switch operation[1] {
            case "+":
                result[id] = .sum(String(operation[0]), String(operation[2]))
            case "-":
                result[id] = .sub(String(operation[0]), String(operation[2]))
            case "*":
                result[id] = .mul(String(operation[0]), String(operation[2]))
            case "/":
                result[id] = .div(String(operation[0]), String(operation[2]))
            default:
                break
            }
        }
        return result
    }

    private func calculate(current: String, operations: [String: Operation]) throws -> Int {
        let operation = operations[current]!
        switch operation {
        case let .number(number):
            return number
        case let .sum(lhs, rhs):
            return try calculate(current: lhs, operations: operations) + calculate(current: rhs, operations: operations)
        case let .sub(lhs, rhs):
            return try calculate(current: lhs, operations: operations) - calculate(current: rhs, operations: operations)
        case let .mul(lhs, rhs):
            return try calculate(current: lhs, operations: operations) * calculate(current: rhs, operations: operations)
        case let .div(lhs, rhs):
            return try calculate(current: lhs, operations: operations) / calculate(current: rhs, operations: operations)
        case .input:
            throw IsInput()
        }
    }

    func calculate(current: String, operations: [String: Operation], mustEqual: Int) -> Int {
        let operation = operations[current]!
        switch operation {
        case let .number(number):
            return number
        case let .sum(lhs, rhs):
            if let result = try? calculate(current: lhs, operations: operations) {
                return calculate(current: rhs, operations: operations, mustEqual: mustEqual - result)
            }
            let result = try! calculate(current: rhs, operations: operations)
            return calculate(current: lhs, operations: operations, mustEqual: mustEqual - result)
        case let .sub(lhs, rhs):
            if let result = try? calculate(current: lhs, operations: operations) {
                return calculate(current: rhs, operations: operations, mustEqual: result - mustEqual)
            }
            let result = try! calculate(current: rhs, operations: operations)
            return calculate(current: lhs, operations: operations, mustEqual: mustEqual + result)
        case let .mul(lhs, rhs):
            if let result = try? calculate(current: lhs, operations: operations) {
                return calculate(current: rhs, operations: operations, mustEqual: mustEqual / result)
            }
            let result = try! calculate(current: rhs, operations: operations)
            return calculate(current: lhs, operations: operations, mustEqual: mustEqual / result)
        case let .div(lhs, rhs):
            if let result = try? calculate(current: lhs, operations: operations) {
                return calculate(current: rhs, operations: operations, mustEqual: result / mustEqual)
            }
            let result = try! calculate(current: rhs, operations: operations)
            return calculate(current: lhs, operations: operations, mustEqual: mustEqual * result)
        case .input:
            return mustEqual
        }
    }
}
