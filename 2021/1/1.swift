import Foundation

let input = try! String(contentsOfFile: "input.txt", encoding: .utf8)

let measurements = input
    .split(separator: "\n")
    .compactMap { Int($0) }

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

print(solve1(measurements: measurements))
print(solve2(measurements: measurements))
