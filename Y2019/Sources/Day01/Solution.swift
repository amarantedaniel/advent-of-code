import Foundation

func calculateRequiredFuel(for mass: Int) -> Int {
    let fuel = mass / 3 - 2
    if fuel > 0 {
        return fuel + calculateRequiredFuel(for: fuel)
    }
    return 0
}

func solve2(input: String) -> Int {
    input
        .split(separator: "\n")
        .compactMap { Int($0) }
        .map(calculateRequiredFuel(for:)).reduce(0, +)
}
