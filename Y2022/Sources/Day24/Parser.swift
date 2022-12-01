import Foundation

enum Parser {
    static func parse(input: String) -> [Instruction] {
        return input.split(separator: "\n").map(instruction(from:))
    }

    private static func instruction(from text: Substring) -> Instruction {
        let elements = text.split(separator: " ")
        switch elements[0] {
        case "inp":
            return .inp(address(from: elements[1]))
        case "add":
            return .add(address(from: elements[1]), element(from: elements[2]))
        case "mul":
            return .mul(address(from: elements[1]), element(from: elements[2]))
        case "div":
            return .div(address(from: elements[1]), element(from: elements[2]))
        case "mod":
            return .mod(address(from: elements[1]), element(from: elements[2]))
        case "eql":
            return .eql(address(from: elements[1]), element(from: elements[2]))
        default:
            fatalError()
        }
    }

    private static func element(from text: Substring) -> Element {
        if let number = Int(text) {
            return .number(number)
        } else {
            return .address(address(from: text))
        }
    }

    private static func address(from text: Substring) -> Address {
        switch text {
        case "w": return \.w
        case "x": return \.x
        case "y": return \.y
        case "z": return \.z
        default:
            fatalError()
        }
    }
}
