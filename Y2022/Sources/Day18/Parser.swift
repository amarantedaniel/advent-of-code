import Foundation

enum Parser {
    static func parse(input: String) -> [Tree] {
        input
            .split(separator: "\n")
            .map(parse(line:))
    }

    enum StackElement: Equatable {
        case open
        case close
        case number(Int)
        case tree(Tree)
    }

    static func parse(line: Substring) -> Tree {
        var stack: [StackElement] = []
        for character in line {
            switch character {
            case "[":
                stack.append(.open)
            case "]":
                stack.append(.close)
            case _:
                if let number = character.wholeNumberValue {
                    stack.append(.number(number))
                }
            }
            processStack(&stack)
        }
        if case .tree(let pair) = stack.last {
            return pair
        }
        fatalError()
    }

    static func processStack(_ stack: inout [StackElement]) {
        switch stack.last {
        case .open:
            break
        case .close:
            stack.removeLast()
            stack.remove(at: stack.lastIndex { $0 == .open }!)
            processStack(&stack)
        case .number(let number):
            switch stack[stack.count - 2] {
            case .number(let prevNumber):
                stack.removeLast(2)
                stack.append(.tree(Tree(left: .leaf(prevNumber), right: .leaf(number))))
            case .tree(let pair):
                stack.removeLast(2)
                stack.append(.tree(Tree(left: .tree(pair), right: .leaf(number))))
            default:
                break
            }
        case .tree(let pair):
            if stack.count == 1 { break }
            switch stack[stack.count - 2] {
            case .number(let number):
                stack.removeLast(2)
                stack.append(.tree(Tree(left: .leaf(number), right: .tree(pair))))
            case .tree(let prevPair):
                stack.removeLast(2)
                stack.append(.tree(Tree(left: .tree(prevPair), right: .tree(pair))))
            default:
                break
            }
        case nil:
            break
        }
    }
}
