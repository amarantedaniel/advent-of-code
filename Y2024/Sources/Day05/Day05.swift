import AdventOfCode

struct Page: Comparable {
    let value: Int
    let isLargerThan: [Int]

    static func < (lhs: Page, rhs: Page) -> Bool {
        rhs.isLargerThan.contains(lhs.value)
    }
}

struct Day05: AdventDay {
    private func parse(input: String) -> [[Page]] {
        let parts = input.components(separatedBy: "\n\n")
        let rules = parse(rules: parts[0])
        return parse(update: parts[1], rules: rules)
    }

    private func parse(update: String, rules: [Int: [Int]]) -> [[Page]] {
        update
            .split(separator: "\n")
            .map { parse(line: $0, rules: rules) }
    }

    private func parse(line: Substring, rules: [Int: [Int]]) -> [Page] {
        line.split(separator: ",")
            .compactMap { Int($0) }
            .map { number in
                Page(value: number, isLargerThan: rules[number] ?? [])
            }
    }

    private func parse(rules: String) -> [Int: [Int]] {
        rules.split(separator: "\n").reduce(into: [:]) { result, line in
            let pair = line.split(separator: "|").compactMap { Int($0) }
            result[pair[1], default: []].append(pair[0])
        }
    }

    func part1(input: String) throws -> Int {
        let update = parse(input: input)
        var result = 0
        for pages in update {
            if pages == pages.sorted() {
                result += pages[pages.count / 2].value
            }
        }
        return result
    }

    func part2(input: String) throws -> Int {
        let update = parse(input: input)
        var result = 0
        for pages in update {
            let sorted = pages.sorted()
            if pages != sorted {
                result += sorted[pages.count / 2].value
            }
        }
        return result
    }
}
