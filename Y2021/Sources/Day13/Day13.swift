import AdventOfCode

enum Axis: String {
    case x, y
}

struct Instruction {
    let axis: Axis
    let amount: Int

    var keyPath: WritableKeyPath<Point, Int> {
        switch axis {
        case .x:
            return \.x
        case .y:
            return \.y
        }
    }
}

struct Point: Hashable {
    var x: Int
    var y: Int
}

struct Day13: AdventDay {
    func stringify(points: [Point]) -> String {
        let maxY = points.map(\.y).max()!
        let maxX = points.map(\.x).max()!
        let set = Set(points)
        return (0...maxY).map { y in
            (0...maxX).reduce("") { line, x in line + (set.contains(Point(x: x, y: y)) ? "█" : " ") }
        }.joined(separator: "\n")
    }

    func fold(points: [Point], instruction: Instruction) -> [Point] {
        var set = Set<Point>()
        for var point in points {
            executeFold(on: &point, value: instruction.amount, keyPath: instruction.keyPath)
            set.insert(point)
        }
        return Array(set)
    }

    func executeFold(on point: inout Point, value: Int, keyPath: WritableKeyPath<Point, Int>) {
        if point[keyPath: keyPath] > value {
            point[keyPath: keyPath] = value - (point[keyPath: keyPath] - value)
        }
    }

    func part1(input: String) -> String {
        let (points, instructions) = Parser.parse(input: input)
        return fold(points: points, instruction: instructions[0]).count.description
    }

    func part2(input: String) -> String {
        let (points, instructions) = Parser.parse(input: input)
        let result = instructions.reduce(points) { points, instruction in
            fold(points: points, instruction: instruction)
        }
        return stringify(points: result)
    }
}
