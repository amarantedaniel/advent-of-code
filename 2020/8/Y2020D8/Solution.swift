enum Output {
    case success(Int)
    case loop(Int)
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
        return .loop(acc)
    }
    return .success(acc)
}

public func solve1(_ input: String) -> Int? {
    let operations = Parser.parse(input: input)
    for _ in 0 ..< operations.count {
        if case let .loop(value) = execute(operations: operations) {
            return value
        }
    }
    return nil
}

public func solve2(_ input: String) -> Int? {
    var operations = Parser.parse(input: input)
    for i in 0 ..< operations.count {
        operations[i] = operations[i].swap()
        switch execute(operations: operations) {
        case let .success(value):
            return value
        case .loop:
            operations[i] = operations[i].swap()
        }
    }
    return nil
}
