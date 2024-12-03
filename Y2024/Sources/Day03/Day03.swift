import AdventOfCode

struct Day03: AdventDay {
    func part1(input: String) throws -> Int {
        let regex = #/mul\((\d+),(\d+)\)/#
        return input.matches(of: regex).reduce(0) { result, match in
            result + Int(match.output.1)! * Int(match.output.2)!
        }
    }

    func part2(input: String) throws -> Int {
        let regex = #/mul\((\d+),(\d+)\)|do\(\)|don't\(\)/#
        var isEnabled = true
        var result = 0
        for match in input.matches(of: regex) {
            switch match.output.0 {
            case "do()":
                isEnabled = true
            case "don't()":
                isEnabled = false
            default:
                guard isEnabled else { continue }
                result += Int(match.output.1!)! * Int(match.output.2!)!
            }
        }
        return result
    }
}
