import Foundation

enum Parser {
    static func parse(input: String) -> ([Point], [Instruction]) {
        let parts = input.components(separatedBy: "\n\n")
        let points = parse(points: parts[0])
        let instructions = parse(instructions: parts[1])
        return (points, instructions)
    }

    private static func parse(points: String) -> [Point] {
        return points
            .split(separator: "\n")
            .map { $0.split(separator: ",") }
            .compactMap { parts in
                guard let x = Int(parts[0]), let y = Int(parts[1]) else { return nil }
                return Point(x: x, y: y)
            }
    }

    private static func parse(instructions: String) -> [Instruction] {
        return instructions
            .split(separator: "\n")
            .compactMap { $0.split(separator: " ").last?.split(separator: "=") }
            .compactMap { parts in
                guard let axis = Axis(rawValue: String(parts[0])), let amout = Int(parts[1]) else { return nil }
                return Instruction(axis: axis, amount: amout)
            }
    }
}
