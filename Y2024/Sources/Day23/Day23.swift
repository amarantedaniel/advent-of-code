import AdventOfCode

struct Day23: AdventDay {
    private func parse(input: String) -> [String: Set<String>] {
        var result: [String: Set<String>] = [:]
        for line in input.split(separator: "\n") {
            let parts = line.split(separator: "-")
            result[String(parts[0]), default: []].insert(String(parts[1]))
            result[String(parts[1]), default: []].insert(String(parts[0]))
        }
        return result
    }

    func largestClique(
        current: Set<String>,
        vertices: Set<String>,
        excluded: Set<String>,
        graph: [String: Set<String>]
    ) -> Set<String> {
        if vertices.isEmpty && excluded.isEmpty {
            return current
        }
        var largest: Set<String> = []
        var vertices = vertices
        var excluded = excluded

        for vertex in vertices {
            let neighbors = graph[vertex, default: []]
            let result = largestClique(
                current: current.union([vertex]),
                vertices: vertices.intersection(neighbors),
                excluded: excluded.intersection(neighbors),
                graph: graph
            )
            if result.count > largest.count {
                largest = result
            }
            vertices.remove(vertex)
            excluded.insert(vertex)
        }
        return largest
    }

    private func findInterconnections(in group: Set<String>, graph: [String: Set<String>]) -> [(String, String)] {
        var result: [(String, String)] = []
        let group = Array(group)
        for i in 0..<group.count {
            for j in i..<group.count {
                if graph[group[i], default: []].contains(group[j]) {
                    result.append((group[i], group[j]))
                }
            }
        }
        return result
    }

    func part1(input: String) throws -> String {
        let graph = parse(input: input)
        var triples: Set<Set<String>> = []

        for (node, connections) in graph where node.starts(with: "t") {
            for tuple in findInterconnections(in: connections, graph: graph) {
                triples.insert([node, tuple.0, tuple.1])
            }
        }
        return "\(triples.count)"
    }

    func part2(input: String) throws -> String {
        let graph = parse(input: input)
        return largestClique(current: [], vertices: Set(graph.keys), excluded: [], graph: graph)
            .sorted()
            .joined(separator: ",")
    }
}
