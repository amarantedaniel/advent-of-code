import Foundation

let input = try! String(contentsOfFile: "input.txt", encoding: .utf8)

let crabs = input
    .split(separator: ",")
    .compactMap { Int($0) }

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

// Part 1
print(solve(crabs: crabs, calculateFuel: { $0 }))
// Part 2
print(solve(crabs: crabs, calculateFuel: calculateFuel(steps:)))
