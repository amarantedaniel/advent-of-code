import AdventOfCode

indirect enum Operation {
    case value(Int)
    case and(String, String)
    case or(String, String)
    case xor(String, String)
}

struct Day24: AdventDay {
    private func parse(input: String) -> [String: Operation] {
        let parts = input.components(separatedBy: "\n\n")
        var result: [String: Operation] = [:]
        parseInitialValues(input: parts[0], into: &result)
        parseOperations(input: parts[1], into: &result)
        return result
    }

    private func parseInitialValues(input: String, into result: inout [String: Operation]) {
        for line in input.split(separator: "\n") {
            let parts = line.components(separatedBy: ": ")
            result[parts[0]] = .value(Int(parts[1])!)
        }
    }

    private func parseOperations(input: String, into result: inout [String: Operation]) {
        for line in input.split(separator: "\n") {
            let parts = line.components(separatedBy: " -> ")
            let operation = parts[0].split(separator: " ")
            switch operation[1] {
            case "AND":
                result[parts[1]] = .and(String(operation[0]), String(operation[2]))
            case "XOR":
                result[parts[1]] = .xor(String(operation[0]), String(operation[2]))
            case "OR":
                result[parts[1]] = .or(String(operation[0]), String(operation[2]))
            default:
                break
            }
        }
    }

    private func process(key: String, map: [String: Operation]) -> Int {
        switch map[key]! {
        case let .value(value):
            return value
        case let .and(lhs, rhs):
            return process(key: lhs, map: map) & process(key: rhs, map: map)
        case let .or(lhs, rhs):
            return process(key: lhs, map: map) | process(key: rhs, map: map)
        case let .xor(lhs, rhs):
            return process(key: lhs, map: map) ^ process(key: rhs, map: map)
        }
    }

    func part1(input: String) throws -> Int {
        let map = parse(input: input)
        let keys = (0...45).map { String(format: "z%02d", $0) }
        var result = ""
        for key in keys {
            result = "\(process(key: key, map: map))\(result)"
        }
        return Int(result, radix: 2)!
    }

    func part2(input: String) throws -> Int {
        throw AdventError.notImplemented
    }
}
