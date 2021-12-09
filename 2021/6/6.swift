import Foundation

func run(fishes: [Int]) -> [Int] {
    let zeroes = fishes[0]
    var rotated = Array(fishes[1...])
    rotated[6] += zeroes
    rotated.append(zeroes)
    return rotated
}

func solve(timers: [Int]) -> Int {
    let fishes = (0...8)
        .map { i in timers.filter { $0 == i }.count }
    return (0..<256)
        .reduce(fishes) { fishes, _ in run(fishes: fishes) }
        .reduce(0, +)
}

let input = try! String(contentsOfFile: "input.txt", encoding: .utf8)

var timers = input
    .split(separator: ",")
    .compactMap { Int($0) }

print(solve(timers: timers))
