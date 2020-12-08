import Foundation

enum Operation {
    case nop(Int)
    case acc(Int)
    case jmp(Int)

    init?(text: Substring) {
        let values = text.split(separator: " ")
        switch values[0] {
        case "nop":
            self = .nop(Int(values[1])!)
        case "acc":
            self = .acc(Int(values[1])!)
        case "jmp":
            self = .jmp(Int(values[1])!)
        default:
            return nil
        }
    }

    func execute(acc: Int, pointer: Int) -> (Int, Int) {
        switch self {
        case .nop:
            return (acc, pointer + 1)
        case let .acc(number):
            return (acc + number, pointer + 1)
        case let .jmp(number):
            return (acc, pointer + number)
        }
    }

    func swap() -> Operation {
        switch self {
        case .acc:
            return self
        case let .jmp(value):
            return .nop(value)
        case let .nop(value):
            return .jmp(value)
        }
    }
}

enum Output {
    case success(Int)
    case loop
}

func execute(operations: [Operation]) -> Output {
    var pointer = 0
    var acc = 0
    var history: [Int] = []

    while !history.contains(pointer), pointer < operations.count {
        history.append(pointer)
        (acc, pointer) = operations[pointer].execute(acc: acc, pointer: pointer)
    }
    if history.contains(pointer) {
        return .loop
    }
    return .success(acc)
}

func solve(operations: inout [Operation]) -> Int {
    for i in 0 ..< operations.count {
        operations[i] = operations[i].swap()
        switch execute(operations: operations) {
        case let .success(value):
            return value
        case .loop:
            operations[i] = operations[i].swap()
        }
    }
    fatalError()
}

let input = try! String(contentsOfFile: "input.txt", encoding: .utf8)
var operations = input.split(separator: "\n").compactMap(Operation.init(text:))

print(solve(operations: &operations))
