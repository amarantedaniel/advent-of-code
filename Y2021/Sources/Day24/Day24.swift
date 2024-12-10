import AdventOfCode

enum ProgramType: Int {
    case increase = 1
    case decrease = 26
}

struct Memory {
    var w: Int = 0
    var x: Int = 0
    var y: Int = 0
    var z: Int = 0
}

typealias Address = WritableKeyPath<Memory, Int>

enum Element {
    case address(Address)
    case number(Int)

    var number: Int? {
        switch self {
        case .address:
            return nil
        case let .number(number):
            return number
        }
    }
}

typealias Program = [Instruction]

enum Instruction {
    case inp(Address)
    case add(Address, Element)
    case mul(Address, Element)
    case div(Address, Element)
    case mod(Address, Element)
    case eql(Address, Element)

    var element: Element? {
        switch self {
        case .inp:
            return nil
        case let .add(_, element):
            return element
        case let .mul(_, element):
            return element
        case let .div(_, element):
            return element
        case let .mod(_, element):
            return element
        case let .eql(_, element):
            return element
        }
    }
}

struct Day24: AdventDay {
    private func value(for element: Element, in memory: Memory) -> Int {
        switch element {
        case let .address(address):
            return memory[keyPath: address]
        case let .number(number):
            return number
        }
    }

    private func execute(instruction: Instruction, memory: inout Memory) {
        switch instruction {
        case .inp:
            fatalError()
        case let .add(address, element):
            memory[keyPath: address] += value(for: element, in: memory)
        case let .mul(address, element):
            memory[keyPath: address] *= value(for: element, in: memory)
        case let .div(address, element):
            memory[keyPath: address] /= value(for: element, in: memory)
        case let .mod(address, element):
            memory[keyPath: address] %= value(for: element, in: memory)
        case let .eql(address, element):
            if memory[keyPath: address] == value(for: element, in: memory) {
                memory[keyPath: address] = 1
            } else {
                memory[keyPath: address] = 0
            }
        }
    }

    private func execute(instructions: [Instruction], input: [Int], memory: inout Memory) -> Memory {
        var input = input
        for instruction in instructions {
            switch instruction {
            case let .inp(address):
                memory[keyPath: address] = input.removeFirst()
            default:
                execute(instruction: instruction, memory: &memory)
            }
        }
        return memory
    }

    func numberToArray(number: Int) -> [Int] {
        return Array(number.description).compactMap(\.wholeNumberValue)
    }

    func arrayToNumber(array: [Int]) -> Int {
        return Int(array.map(\.description).joined())!
    }

    private func debug(input: String, number: [Int]) -> Memory {
        let instructions = Parser.parse(input: input)
        var memory = Memory()
        return execute(instructions: instructions, input: number, memory: &memory)
    }

    private func split(instructions: [Instruction]) -> [[Instruction]] {
        let size = 18
        var result: [[Instruction]] = []
        for i in 0..<14 {
            result.append(Array(instructions[(i * size)..<((i * size) + size)]))
        }
        return result
    }

    func normalize(number: Int, types: [ProgramType]) -> [Int?] {
        var array = numberToArray(number: number)
        return types.map { type in
            switch type {
            case .increase:
                return array.removeFirst()
            case .decrease:
                return nil
            }
        }
    }

    private func solve(input: String, stride: StrideTo<Int>) -> Int {
        let instructions = Parser.parse(input: input)
        let split = split(instructions: instructions)
        let increments = split.map { $0[15] }.compactMap(\.element?.number)
        let mod = split.map { $0[5] }.compactMap(\.element?.number)
        let types = split.map { $0[4] }.compactMap(\.element?.number).compactMap(ProgramType.init(rawValue:))

        for i in stride {
            var z = 0
            var result: [Int] = []
            let inputArray = normalize(number: i, types: types)
            if inputArray.contains(0) {
                continue
            }
            for index in 0..<inputArray.count {
                if let inputNumber = inputArray[index] {
                    z = z * 26 + inputNumber + increments[index]
                    result.append(inputNumber)
                } else {
                    let aux = (z % 26) + mod[index]
                    if !(1...9).contains(aux) {
                        break
                    }
                    z /= 26
                    result.append(aux)
                }
            }
            if z == 0 {
                return arrayToNumber(array: result)
            }
        }
        fatalError()
    }

    func part1(input: String) -> Int {
        solve(input: input, stride: stride(from: 9_999_999, to: 999_999, by: -1))
    }

    func part2(input: String) -> Int {
        solve(input: input, stride: stride(from: 1_111_111, to: 9_999_999, by: 1))
    }
}
