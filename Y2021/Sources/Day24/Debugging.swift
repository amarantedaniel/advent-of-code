import Foundation

extension Instruction: CustomStringConvertible {
    var description: String {
        switch self {
        case let .inp(address):
            return "inp \(address)"
        case let .add(address, element):
            return "add \(address) \(element)"
        case let .mul(address, element):
            return "mul \(address) \(element)"
        case let .div(address, element):
            return "div \(address) \(element)"
        case let .mod(address, element):
            return "mod \(address) \(element)"
        case let .eql(address, element):
            return "eql \(address) \(element)"
        }
    }
}

extension Element: CustomStringConvertible {
    var description: String {
        switch self {
        case let .address(address):
            return address.description
        case let .number(number):
            return number.description
        }
    }
}

extension Address: CustomStringConvertible {
    public var description: String {
        switch self {
        case \.w: return "w"
        case \.x: return "x"
        case \.y: return "y"
        case \.z: return "z"
        default: fatalError()
        }
    }
}
