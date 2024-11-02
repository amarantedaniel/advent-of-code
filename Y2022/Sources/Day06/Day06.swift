import AdventOfCode
import Foundation

struct Day06: AdventDay {
    func part1(input: String) -> Int {
        solve(input: input, windowSize: 4)
    }

    func part2(input: String) -> Int {
        solve(input: input, windowSize: 14)
    }

    private func solve(input: String, windowSize: Int) -> Int {
        for i in 0..<input.count - windowSize {
            let start = input.index(input.startIndex, offsetBy: i)
            let end = input.index(input.startIndex, offsetBy: i + windowSize)
            let window = input[start..<end]
            if window.count == Set(window).count {
                return i + windowSize
            }
        }
        fatalError()
    }
}
