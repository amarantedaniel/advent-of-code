import AdventOfCode

struct Day05: AdventDay {
    private func parse(input: String) -> ([ClosedRange<Int>], [Int]) {
        let parts = input.split(separator: "\n\n")
        let ranges = parts[0]
            .split(separator: "\n")
            .map {
                let parts = $0
                    .split(separator: "-")
                    .map { Int($0)! }
                return parts[0] ... parts[1]
            }
        let ids = parts[1].split(separator: "\n").compactMap { Int($0) }
        return (ranges, ids)
    }

    func part1(input: String) throws -> Int {
        let (ranges, ids) = parse(input: input)
        var count = 0
        for id in ids {
            for range in ranges {
                if range.contains(id) {
                    count += 1
                    break
                }
            }
        }
        return count
    }

    func part2(input: String) throws -> Int {
        let (ranges, _) = parse(input: input)
        var result = 0
        var current = 0
        for range in ranges.sorted(by: { $0.lowerBound < $1.lowerBound }) {
            if current < range.lowerBound {
                result += range.count
                current = range.upperBound + 1
                continue
            } else if current > range.upperBound {
                continue
            } else {
                result += (current ... range.upperBound).count
                current = range.upperBound + 1
            }
        }
        return result
    }
}
