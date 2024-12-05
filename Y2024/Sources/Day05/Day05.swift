import AdventOfCode

struct Day05: AdventDay {
    private func parse(input: String) -> ([Int: [Int]], [[Int]]) {
        let parts = input.components(separatedBy: "\n\n")
        return (
            parse(rules: parts[0]),
            parse(update: parts[1])
        )
    }

    private func parse(update: String) -> [[Int]] {
        update.split(separator: "\n").map { line in
            line.split(separator: ",").compactMap { Int($0) }
        }
    }

    private func parse(rules: String) -> [Int: [Int]] {
        rules.split(separator: "\n").reduce(into: [:]) { result, line in
            let pair = line.split(separator: "|").compactMap { Int($0) }
            result[pair[1], default: []].append(pair[0])
        }
    }

    private func sort(rules: [Int: [Int]], pages: inout [Int]) -> Bool {
        var alreadySorted = true
        for i in 0..<pages.count {
            for j in i..<pages.count {
                guard let numbers = rules[pages[i]] else {
                    continue
                }
                if numbers.contains(pages[j]) {
                    let aux = pages[i]
                    pages[i] = pages[j]
                    pages[j] = aux
                    alreadySorted = false
                }
            }
        }
        return alreadySorted
    }

    func part1(input: String) throws -> Int {
        let (rules, update) = parse(input: input)
        var result = 0
        for pages in update {
            var pages = pages
            if sort(rules: rules, pages: &pages) {
                result += pages[pages.count / 2]
            }
        }
        return result
    }

    func part2(input: String) throws -> Int {
        let (rules, update) = parse(input: input)
        var result = 0
        for pages in update {
            var pages = pages
            if !sort(rules: rules, pages: &pages) {
                result += pages[pages.count / 2]
            }
        }
        return result
    }
}
