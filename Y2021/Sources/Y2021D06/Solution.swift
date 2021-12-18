import Foundation

func run(fishes: [Int]) -> [Int] {
    let zeroes = fishes[0]
    var rotated = Array(fishes[1...])
    rotated[6] += zeroes
    rotated.append(zeroes)
    return rotated
}

func solve(timers: [Int], times: Int) -> Int {
    let fishes = (0...8)
        .map { i in timers.filter { $0 == i }.count }
    return (0..<times)
        .reduce(fishes) { fishes, _ in run(fishes: fishes) }
        .reduce(0, +)
}

func solve1(input: String) -> Int {
    let timers = input
        .split(separator: ",")
        .compactMap { Int($0) }
    return solve(timers: timers, times: 80)
}

func solve2(input: String) -> Int {
    let timers = input
        .split(separator: ",")
        .compactMap { Int($0) }
    return solve(timers: timers, times: 256)
}
