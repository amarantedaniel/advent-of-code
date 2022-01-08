import Foundation

enum Parser {
    static func parse(input: String) -> [Step] {
        return input.split(separator: "\n").map(parse(line:))
    }

    private static func parse(line: Substring) -> Step {
        let parts = line.split(separator: " ")
        let isOn = parts[0] == "on"
        let ranges = parts[1]
            .split(separator: ",")
            .map { $0.dropFirst(2) }
            .map(range(from:))
        return Step(on: isOn, cube: Cube(x: ranges[0], y: ranges[1], z: ranges[2]))
    }

    private static func range(from substring: Substring) -> Range<Int> {
        let numbers = substring.components(separatedBy: "..").compactMap { Int($0) }
        return Range(numbers[0]...numbers[1])
    }
}
