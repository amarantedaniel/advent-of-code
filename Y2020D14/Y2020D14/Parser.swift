enum Parser {
    private enum Input {
        case mask(String)
        case op(Int, Int)
    }

    static func parse(input: String, execute: (String, Int, Int) -> Void) {
        var currentMask: String?
        for line in input.split(separator: "\n") {
            switch parse(line: line) {
            case let .mask(value):
                currentMask = value
            case let .op(address, number):
                execute(currentMask!, address, number)
            }
        }
    }

    private static func parse(line: Substring) -> Input {
        let values = line.components(separatedBy: " = ")
        if values[0] == "mask" {
            return .mask(values[1])
        }
        let address = Int(values[0].components(separatedBy: CharacterSet.decimalDigits.inverted).joined())!
        let value = Int(values[1])!
        return .op(address, value)
    }
}
