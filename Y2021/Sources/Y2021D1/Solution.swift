import Foundation

private func solve1(measurements: [Int]) -> Int {
    var count = 0
    for i in 1 ..< measurements.count {
        if measurements[i - 1] < measurements[i] {
            count += 1
        }
    }
    return count
}

private func solve2(measurements: [Int]) -> Int {
    var count = 0
    for i in 3..<measurements.count {
        let prevWindow = measurements[i - 3] + measurements[i - 2] + measurements[i - 1]
        let newWindow = measurements[i - 2] + measurements[i - 1] + measurements[i]
        if newWindow > prevWindow {
            count += 1
        }
    }
    return count
}

func solve1(input: String) -> Int {
    let measurements = input
        .split(separator: "\n")
        .compactMap { Int($0) }
    return solve1(measurements: measurements)
}

func solve2(input: String) -> Int {
    let measurements = input
        .split(separator: "\n")
        .compactMap { Int($0) }
    return solve2(measurements: measurements)
}
