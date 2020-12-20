import Foundation

extension String {
    func padStart(_ padding: Int) -> String {
        var padded = self
        for _ in 0 ..< (padding - count) {
            padded = "0" + padded
        }
        return padded
    }
}

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

struct Operation {
    let mask: String
    let number: Int

    func execute() -> Int {
        let binary = String(number, radix: 2).padStart(mask.count)
        return Int(String(zip(Array(binary), Array(mask)).map { $1 == "X" ? $0 : $1 }), radix: 2)!
    }
}

func solve1(input: String) {
    var operations = [Int: Operation]()
    Parser.parse(input: input) { mask, address, number in
        operations[address] = Operation(mask: mask, number: number)
    }
    let result = operations.values.reduce(0) { $0 + $1.execute() }
    print(result)
}

func getAddresses(from address: Int, using mask: String) -> [Int] {
    let binary = String(address, radix: 2).padStart(mask.count)
    let floatingAddress = zip(Array(binary), Array(mask)).map { $1 == "1" || $1 == "X" ? $1 : $0 }
    var addresses: [[Character]] = [[]]
    for bit in floatingAddress {
        if bit == "X" {
            var temp1 = addresses
            var temp2 = addresses
            for i in 0 ..< addresses.count {
                temp1[i].append("0")
                temp2[i].append("1")
            }
            addresses = temp1 + temp2
        } else {
            for i in 0 ..< addresses.count {
                addresses[i].append(bit)
            }
        }
    }

    return addresses.map { Int(String($0), radix: 2)! }
}

func solve2(input: String) {
    var memory: [Int: Int] = [:]
    Parser.parse(input: input) { mask, address, number in
        for address in getAddresses(from: address, using: mask) {
            memory[address] = number
        }
    }
    print(memory.values.reduce(0, +))
}

let input = try! String(contentsOfFile: "input.txt", encoding: .utf8)

solve1(input: input)
solve2(input: input)
