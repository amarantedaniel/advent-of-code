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
