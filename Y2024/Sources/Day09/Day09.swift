import AdventOfCode

struct Day09: AdventDay {
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

    private func moveInBlocks(memory: inout [Int?]) {
        var i = memory.count - 1
        var current = memory[i]
        var endIndex = memory.count - 1
        while i > 0 {
            defer { i -= 1 }
            if memory[i] == current {
                continue
            }
            if let space = findSpace(of: endIndex - i, in: memory, until: i + 1) {
                let aux = memory[(i + 1)...endIndex]
                memory[(i + 1)...endIndex] = memory[space]
                memory[space] = aux
            }
            endIndex = i
            current = memory[i]
        }
    }

    private func findSpace(of size: Int, in memory: [Int?], until: Int) -> Range<Int>? {
        var i = 0
        while i < until {
            if memory[i] == nil {
                for j in (i + 1)...until {
                    if j - i == size {
                        return i..<j
                    }
                    if memory[j] != nil {
                        i = j
                        break
                    }
                }
            } else {
                i += 1
            }
        }
        return nil
    }

    func part2(input: String) throws -> Int {
        var memory = parse(input: input)
        moveInBlocks(memory: &memory)
        return checksum(memory: memory)
    }
}
