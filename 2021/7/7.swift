import Foundation

let input = try! String(contentsOfFile: "input.txt", encoding: .utf8)

let crabs = input
    .split(separator: ",")
    .compactMap { Int($0) }

var minimumSum = Int.max
for i in crabs.min()!...crabs.max()! {
    let sum = crabs.reduce(0) { acc, crab in
        acc + calculateFuel(steps: abs(crab - i))
    }
    if sum < minimumSum {
        minimumSum = sum
    }
}

func calculateFuel(steps: Int) -> Int {
    if steps == 0 { return steps }
    return steps + calculateFuel(steps: steps - 1)
}

print(minimumSum)
