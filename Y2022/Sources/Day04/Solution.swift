import Foundation

private func parse(input: String) -> [[ClosedRange<Int>]] {
    let pairs = input.split(separator: "\n")
    return pairs.map { pair in
        pair.split(separator: ",")
            .map { range in
                let numbers = range.split(separator: "-").compactMap { Int($0) }
                return numbers[0] ... numbers[1]
            }
    }
}

private func isContained(ranges: [ClosedRange<Int>]) -> Bool {
    let first = ranges[0].lowerBound >= ranges[1].lowerBound
        && ranges[0].upperBound <= ranges[1].upperBound
    let second = ranges[1].lowerBound >= ranges[0].lowerBound
        && ranges[1].upperBound <= ranges[0].upperBound
    return first || second
}

private func overlaps(ranges: [ClosedRange<Int>]) -> Bool {
    return ranges[0].overlaps(ranges[1])
}

func solve1(input: String) -> Int {
    return parse(input: input)
        .filter(isContained(ranges:))
        .count
}

func solve2(input: String) -> Int {
    return parse(input: input)
        .filter(overlaps(ranges:))
        .count
}
