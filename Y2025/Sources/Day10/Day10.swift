import AdventOfCode

struct Input {
    let goal: [Bool]
    let buttons: [[Int]]
}

struct State {
    let lights: [Bool]
    let count: Int
}

struct Day10: AdventDay {
    private func parse(input: String) -> [Input] {
        input.split(separator: "\n").map(parse(line:))
    }

    private func parse(line: Substring) -> Input {
        return Input(
            goal: parseState(line: line),
            buttons: parseButtons(line: line)
        )
    }

    private func parseState(line: Substring) -> [Bool] {
        guard let match = try? /\[([#.]+)\]/.firstMatch(in: line) else {
            fatalError()
        }
        return Array(match.1).map { $0 == "#" }
    }

    private func parseButtons(line: Substring) -> [[Int]] {
        line
            .matches(of: /\((\d+(?:,\d+)*)\)/)
            .map { $0.1.split(separator: ",").map { Int($0)! } }
    }

    func part1(input: String) throws -> Int {
        var result = 0
        for input in parse(input: input) {
            result += solve(input: input)
        }
        return result
    }

    func solve(input: Input) -> Int {
        var queue: [State] = [State(lights: input.goal.map { _ in false }, count: 0)]
        while !queue.isEmpty {
            let state = queue.removeFirst()
            if state.lights == input.goal {
                return state.count
            }
            for buttons in input.buttons {
                let lights = apply(button: buttons, state: state.lights)
                if !queue.contains(where: { $0.lights == lights }) {
                    queue.append(State(lights: lights, count: state.count + 1))
                }
            }
        }
        return -1
    }

    private func apply(button: [Int], state: [Bool]) -> [Bool] {
        var state = state
        for index in button {
            state[index].toggle()
        }
        return state
    }

    func part2(input _: String) throws -> Int {
        throw AdventError.notImplemented
    }
}
