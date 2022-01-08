import Foundation

enum Parser {
    static func parse(input: String) -> [Cube] {
        return input.split(separator: "\n").map(parse(line:))
    }

    private static func parse(line: Substring) -> Cube {
        let parts = line.split(separator: " ")
        let isOn = parts[0] == "on"
        let ranges = parts[1]
            .split(separator: ",")
            .map { $0.dropFirst(2) }
            .map(range(from:))
        return Cube(on: isOn, x: ranges[0], y: ranges[1], z: ranges[2])
    }

    private static func range(from substring: Substring) -> ClosedRange<Int> {
        let numbers = substring.components(separatedBy: "..").compactMap { Int($0) }
        return numbers[0]...numbers[1]
    }
}
