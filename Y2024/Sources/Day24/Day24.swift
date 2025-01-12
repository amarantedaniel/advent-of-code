import AdventOfCode

enum Output {
    case out(String)
    case swap(String, String)
}

indirect enum Operation: Equatable {
    case value(Int)
    case and(String, String)
    case or(String, String)
    case xor(String, String)

    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.value(lhsValue), .value(rhsValue)):
            return lhsValue == rhsValue
        case let (.and(lhsA, lhsB), .and(rhsA, rhsB)),
             let (.or(lhsA, lhsB), .or(rhsA, rhsB)),
             let (.xor(lhsA, lhsB), .xor(rhsA, rhsB)):
            return (lhsA == rhsA && lhsB == rhsB) || (lhsA == rhsB && lhsB == rhsA)
        default:
            return false
        }
    }
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

    private func process(key: String, circuit: [String: Operation]) -> Int {
        switch circuit[key]! {
        case let .value(value):
            return value
        case let .and(lhs, rhs):
            return process(key: lhs, circuit: circuit) & process(key: rhs, circuit: circuit)
        case let .or(lhs, rhs):
            return process(key: lhs, circuit: circuit) | process(key: rhs, circuit: circuit)
        case let .xor(lhs, rhs):
            return process(key: lhs, circuit: circuit) ^ process(key: rhs, circuit: circuit)
        }
    }

    private func run(circuit: [String: Operation], variable: String, count: Int) -> String {
        let keys = (0...count).map { String(format: "\(variable)%02d", $0) }
        return keys.reduce("") { result, key in
            "\(process(key: key, circuit: circuit))\(result)"
        }
    }

    func part1(input: String) throws -> String {
        let circuit = parse(input: input)
        let result = run(circuit: circuit, variable: "z", count: 45)
        return "\(Int(result, radix: 2)!)"
    }

    private func validateHalfAdder(index: Int, circuit: [String: Operation]) -> String? {
        let zID = String(format: "z%02d", index)
        let xID = String(format: "x%02d", index)
        let yID = String(format: "y%02d", index)
        guard case let .xor(lhs, rhs) = circuit[zID] else {
            return nil
        }
        guard (lhs == xID && rhs == yID) || (lhs == yID && rhs == xID) else {
            return nil
        }
        return find(operation: .and(xID, yID), in: circuit)
    }

    private func validateFullAdder(index: Int, cin: String, circuit: [String: Operation]) -> Output? {
        let x = String(format: "x%02d", index)
        let y = String(format: "y%02d", index)
        let z = String(format: "z%02d", index)
        let xyXor = find(operation: .xor(x, y), in: circuit)!
        let xyAnd = find(operation: .and(x, y), in: circuit)!
        guard let b = find(operation: .xor(xyXor, cin), in: circuit) else {
            return .swap(xyXor, xyAnd)
        }
        guard b == z else {
            return .swap(b, z)
        }
        guard let c = find(operation: .and(xyXor, cin), in: circuit) else {
            return .swap(xyXor, xyAnd)
        }
        guard let e = find(operation: .or(c, xyAnd), in: circuit) else {
            return .swap(xyXor, xyAnd)
        }
        return .out(e)
    }

    private func find(operation: Operation, in circuit: [String: Operation]) -> String? {
        circuit.first { $1 == operation }?.key
    }

    func part2(input: String) throws -> String {
        var circuit = parse(input: input)
        var cin = validateHalfAdder(index: 0, circuit: circuit)!
        var result: [String] = []
        var i = 1
        while i < 45 {
            switch validateFullAdder(index: i, cin: cin, circuit: circuit) {
            case let .out(output):
                cin = output
                i += 1
            case let .swap(a, b):
                result.append(a)
                result.append(b)
                let aux = circuit[a]
                circuit[a] = circuit[b]
                circuit[b] = aux
            case nil:
                fatalError()
            }
        }
        return result.sorted().joined(separator: ",")
    }
}
