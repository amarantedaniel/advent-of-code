import AdventOfCode

struct Day01: AdventDay {
    func part1(input: String) throws -> Int {
        var pointingTo = 50
        var result = 0
        for line in input.split(separator: "\n") {
            let number = Int(line.dropFirst())!
            let direction = line.first == "R" ? 1 : -1
            let destination = pointingTo + number * direction
            pointingTo = (100 + destination % 100) % 100
            if pointingTo == 0 {
                result += 1
            }
        }
        return result
    }

    func part2(input: String) throws -> Int {
        var pointingTo = 50
        var result = 0
        for line in input.split(separator: "\n") {
            let number = Int(line.dropFirst())!
            let direction = line.first == "R" ? 1 : -1
            let destination = pointingTo + number * direction
            for i in stride(from: pointingTo + direction, to: destination + direction, by: direction) {
                pointingTo = (100 + i % 100) % 100
                if pointingTo == 0 {
                    result += 1
                }
            }
        }
        return result
    }
}
