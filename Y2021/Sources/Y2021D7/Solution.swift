import Foundation

func calculateFuel(steps: Int) -> Int {
    if steps == 0 { return steps }
    return steps + calculateFuel(steps: steps - 1)
}

func solve(crabs: [Int], calculateFuel: (Int) -> Int) -> Int {
    var minimumSum = Int.max
    for i in crabs.min()!...crabs.max()! {
        let sum = crabs.reduce(0) { acc, crab in
            acc + calculateFuel(abs(crab - i))
        }
        if sum < minimumSum {
            minimumSum = sum
        }
    }
    return minimumSum
}

func solve1(input: String) -> Int {
    let crabs = input.split(separator: ",").compactMap { Int($0) }
    return solve(crabs: crabs, calculateFuel: { $0 })
}

func solve2(input: String) -> Int {
    let crabs = input.split(separator: ",").compactMap { Int($0) }
    return solve(crabs: crabs, calculateFuel: calculateFuel(steps:))
}
