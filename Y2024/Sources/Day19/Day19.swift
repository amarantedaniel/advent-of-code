import AdventOfCode

extension Substring {
    subscript(range: PartialRangeFrom<Int>) -> Substring {
        let startIndex = self.index(self.startIndex, offsetBy: range.lowerBound)
        return self[startIndex...]
    }
}

struct Day19: AdventDay {
    private func parse(input: String) -> ([String], [String]) {
        let components = input.components(separatedBy: "\n\n")
        let patterns = components[0]
            .components(separatedBy: ", ")
        let designs = components[1]
            .components(separatedBy: "\n")
            .filter { !$0.isEmpty }
        return (patterns, designs)
    }

    private func isPossible(design: Substring, with patterns: [String]) -> Bool {
        if design.isEmpty {
            return true
        }
        for pattern in patterns where design.starts(with: pattern) {
            if isPossible(design: design[pattern.count...], with: patterns) {
                return true
            }
        }
        return false
    }

    private func countPossibilities(
        of design: Substring,
        with patterns: [String],
        cache: inout [Substring: Int]
    ) -> Int {
        if let value = cache[design] {
            return value
        }
        if design.isEmpty {
            return 1
        }
        var count = 0
        for pattern in patterns where design.starts(with: pattern) {
            count += countPossibilities(of: design[pattern.count...], with: patterns, cache: &cache)
        }
        cache[design] = count
        return count
    }

    func part1(input: String) throws -> Int {
        let (patterns, designs) = parse(input: input)
        return designs
            .filter { isPossible(design: $0[...], with: patterns) }
            .count
    }

    func part2(input: String) throws -> Int {
        let (patterns, designs) = parse(input: input)
        var cache: [Substring: Int] = [:]
        return designs
            .reduce(0) {
                $0 + countPossibilities(of: $1[...], with: patterns, cache: &cache)
            }
    }
}
