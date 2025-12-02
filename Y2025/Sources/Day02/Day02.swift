import AdventOfCode

struct Day02: AdventDay {
    private func parse(input: String) -> [ClosedRange<Int>] {
        input
            .split(separator: ",")
            .map {
                $0.split(separator: "-")
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                    .map { Int($0)! }
            }
            .map { $0[0] ... $0[1] }
    }

    func part1(input: String) throws -> Int {
        var invalidIds: [Int] = []
        let ranges = parse(input: input)
        for range in ranges {
            for number in range {
                let characters = Array("\(number)")
                if characters.count % 2 == 0 {
                    let first = characters[..<(characters.count / 2)]
                    let second = characters[(characters.count / 2)...]
                    if first == second {
                        invalidIds.append(number)
                    }
                }
            }
        }
        return invalidIds.reduce(0, +)
    }

    func part2(input: String) throws -> Int {
        var invalidIds: [Int] = []
        let ranges = parse(input: input)
        for range in ranges {
            for number in range {
                let characters = Array("\(number)")
                if characters.count < 2 { continue }
                for numberOfParts in 2...characters.count {
                    if characters.count % numberOfParts == 0 {
                        var parts: [ArraySlice<Character>] = []
                        for i in stride(from: 0, to: characters.count, by: characters.count / numberOfParts) {
                            parts.append(characters[i..<(i + characters.count / numberOfParts)])
                        }
                        if Set(parts).count == 1 {
                            invalidIds.append(number)
                        }
                    }
                }
            }
        }
        return Set(invalidIds).reduce(0, +)
    }
}
