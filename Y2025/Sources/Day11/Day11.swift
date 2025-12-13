import AdventOfCode

struct Cache: Hashable {
    let node: String
    let required: Set<String>
}

struct Day11: AdventDay {
    private func parse(input: String) -> [String: [String]] {
        var map: [String: [String]] = [:]
        for line in input.split(separator: "\n") {
            let nodes = line.split(separator: " ")
            map[String(nodes[0].dropLast())] = nodes[1...].map { String($0) }
        }
        return map
    }

    func part1(input: String) throws -> Int {
        let map = parse(input: input)
        var cache: [Cache: Int] = [:]
        return countPaths(
            node: "you", map: map, cache: &cache, required: []
        )
    }

    func part2(input: String) throws -> Int {
        let map = parse(input: input)
        var cache: [Cache: Int] = [:]
        return countPaths(
            node: "svr", map: map, cache: &cache, required: ["fft", "dac"]
        )
    }

    private func countPaths(
        node: String,
        map: [String: [String]],
        cache: inout [Cache: Int],
        required: Set<String>
    ) -> Int {
        if let value = cache[Cache(node: node, required: required)] {
            return value
        }
        if node == "out" {
            return required.isEmpty ? 1 : 0
        }
        var count = 0
        for value in map[node]! {
            count += countPaths(
                node: value,
                map: map,
                cache: &cache,
                required: required.subtracting([value])
            )
        }
        cache[Cache(node: node, required: required)] = count
        return count
    }
}
