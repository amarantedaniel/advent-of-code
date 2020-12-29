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

public func solve1(_ input: String) -> Int {
    var operations = [Int: Operation]()
    Parser.parse(input: input) { mask, address, number in
        operations[address] = Operation(mask: mask, number: number)
    }
    return operations.values.reduce(0) { $0 + $1.execute() }
}

public func solve2(_ input: String) -> Int {
    var memory: [Int: Int] = [:]
    Parser.parse(input: input) { mask, address, number in
        for address in getAddresses(from: address, using: mask) {
            memory[address] = number
        }
    }
    return memory.values.reduce(0, +)
}
