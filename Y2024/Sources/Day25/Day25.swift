import AdventOfCode

enum Pattern {
    case lock([Int])
    case key([Int])

    var isKey: Bool {
        switch self { case .lock: false; case .key: true }
    }

    var isLock: Bool {
        switch self { case .lock: true; case .key: false }
    }

    var values: [Int] {
        switch self {
        case let .lock(values): values
        case let .key(values): values
        }
    }
}

struct Day25: AdventDay {
    private func parse(input: String) -> [Pattern] {
        let patterns = input.components(separatedBy: "\n\n")
        return patterns.map(parse(pattern:))
    }

    private func parse(pattern: String) -> Pattern {
        let lines = pattern.split(separator: "\n")
        if lines[0] == "#####" {
            return .lock(parse(lines: lines))
        }
        return .key(parse(lines: lines))
    }

    private func parse(lines: [Substring]) -> [Int] {
        var result = [-1, -1, -1, -1, -1]
        for line in lines {
            for (index, character) in line.enumerated() {
                result[index] += character == "#" ? 1 : 0
            }
        }
        return result
    }

    private func fits(key: [Int], lock: [Int]) -> Bool {
        for i in 0..<key.count {
            if key[i] + lock[i] > 5 {
                return false
            }
        }
        return true
    }

    func part1(input: String) throws -> Int {
        let patterns = parse(input: input)
        var result = 0
        for key in patterns where key.isKey {
            for lock in patterns where lock.isLock {
                result += fits(key: key.values, lock: lock.values) ? 1 : 0
            }
        }
        return result
    }

    func part2(input: String) throws -> Int {
        throw AdventError.notImplemented
    }
}
