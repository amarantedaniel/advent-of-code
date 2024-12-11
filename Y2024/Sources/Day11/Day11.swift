import AdventOfCode
import Foundation

struct State: Hashable {
    let stones: [Int]
    let remaining: Int
}

struct Day11: AdventDay {
    private func parse(input: String) -> [Int] {
        input
            .split(separator: "\n")[0]
            .split(separator: " ")
            .map { Int($0)! }
    }

    private func blink(
        stones: [Int],
        cache: inout [State: Int],
        remaining: Int
    ) -> Int {
        if let result = cache[State(stones: stones, remaining: remaining)] {
            return result
        }
        if remaining == 0 {
            return stones.count
        }
        var result = 0
        for stone in stones {
            result += blink(
                stones: blink(stone: stone), cache: &cache, remaining: remaining - 1
            )
        }
        cache[State(stones: stones, remaining: remaining)] = result
        return result
    }

    private func blink(stone: Int) -> [Int] {
        if stone == 0 {
            return [1]
        }
        let digits = "\(stone)"
        if digits.count % 2 == 0 {
            let index = digits.index(digits.startIndex, offsetBy: digits.count / 2)
            return [Int(digits[..<index])!, Int(digits[index...])!]
        }
        return [stone * 2_024]
    }

    func part1(input: String) throws -> Int {
        let stones = parse(input: input)
        var cache: [State: Int] = [:]
        return blink(stones: stones, cache: &cache, remaining: 25)
    }

    func part2(input: String) throws -> Int {
        let stones = parse(input: input)
        var cache: [State: Int] = [:]
        return blink(stones: stones, cache: &cache, remaining: 75)
    }
}
