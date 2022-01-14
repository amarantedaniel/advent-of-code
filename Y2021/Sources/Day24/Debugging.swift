import Foundation

extension Instruction: CustomStringConvertible {
    var description: String {
        switch self {
        case .inp(let address):
            return "inp \(address)"
        case .add(let address, let element):
            return "add \(address) \(element)"
        case .mul(let address, let element):
            return "mul \(address) \(element)"
        case .div(let address, let element):
            return "div \(address) \(element)"
        case .mod(let address, let element):
            return "mod \(address) \(element)"
        case .eql(let address, let element):
            return "eql \(address) \(element)"
        }
    }
}

extension Element: CustomStringConvertible {
    var description: String {
        switch self {
        case .address(let address):
            return address.description
        case .number(let number):
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
