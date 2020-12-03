import Foundation

func calculateRequiredFuel(for mass: Int) -> Int {
    let fuel = mass / 3 - 2
    if fuel > 0 {
        return fuel + calculateRequiredFuel(for: fuel)
    }
    return 0
}

let input = try! String(contentsOfFile: "input.txt", encoding: .utf8)
                    .split(separator: "\n")
                    .compactMap { Int($0) }

print(input.map(calculateRequiredFuel(for:)).reduce(0, +))
