import AdventOfCode

struct Day22: AdventDay {
    private func next(number: Int) -> Int {
        var number = ((number * 64) ^ number) % 16_777_216
        number = ((number / 32) ^ number) % 16_777_216
        number = ((number * 2_048) ^ number) % 16_777_216
        return number
    }

    private func finalSecretNumber(number: Int) -> Int {
        var number = number
        for _ in 0..<2_000 {
            number = next(number: number)
        }
        return number
    }

    func ranges(number: Int) -> [[Int]: Int] {
        var number = number
        var diffs: [Int] = []

        var results: [[Int]: Int] = [:]

        for _ in 0..<2_000 {
            let previous = number % 10
            number = next(number: number)
            let current = number % 10
            let diff = current - previous
            diffs.append(diff)
            if diffs.count > 4 {
                diffs.removeFirst()
            }
            if diffs.count == 4 && results[diffs] == nil {
                results[diffs] = current
            }
        }
        return results
    }

    func part1(input: String) throws -> Int {
        let numbers = input.split(separator: "\n").compactMap { Int($0) }
        return numbers.reduce(0) {
            $0 + finalSecretNumber(number: $1)
        }
    }

    func part2(input: String) throws -> Int {
        let numbers = input.split(separator: "\n").compactMap { Int($0) }
        let maps = numbers.map { ranges(number: $0) }
        var maximum = 0
        for range in Set(maps.flatMap(\.keys)) {
            var count = 0
            for map in maps {
                count += map[range, default: 0]
            }
            maximum = max(maximum, count)
        }
        return maximum
    }
}
