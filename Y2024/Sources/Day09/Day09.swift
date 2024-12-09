import AdventOfCode

struct Day09: AdventDay {
    private func printMemory(memory: [Int?]) {
        print(
            memory.map {
                $0?.description ?? "."
            }.joined()
        )
    }

    private func parse(input: String) -> [Int?] {
        var result: [Int?] = []
        let numbers = Array(input).compactMap(\.wholeNumberValue)
        var index = 0
        var isEmpty = false
        for number in numbers {
            let value = isEmpty ? nil : index
            result.append(contentsOf: Array(repeating: value, count: number))
            if !isEmpty {
                index += 1
            }
            isEmpty.toggle()
        }
        return result
    }

    private func move(memory: inout [Int?]) {
        var i = 0
        var j = memory.count - 1
        while i < j {
            if memory[i] == nil && memory[j] != nil {
                memory[i] = memory[j]
                memory[j] = nil
            }
            if memory[i] != nil {
                i += 1
            }
            if memory[j] == nil {
                j -= 1
            }
        }
    }

    func checksum(memory: [Int?]) -> Int {
        var result = 0
        for i in 0..<memory.count {
            result += i * (memory[i] ?? 0)
        }

        return result
    }

    func part1(input: String) throws -> Int {
        var memory = parse(input: input)
        move(memory: &memory)
        return checksum(memory: memory)
    }

    func part2(input: String) throws -> Int {
        var memory = parse(input: input)
        // TODO
        return checksum(memory: memory)
    }
}
