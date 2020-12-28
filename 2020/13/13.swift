import Foundation

let input = try! String(contentsOfFile: "input.txt", encoding: .utf8)
let values = input.split(separator: "\n")
let departure = Int(values[0])!
let times = values[1].split(separator: ",").map { Int($0) }

func modularInverse(a: Int, c: Int) -> Int {
    for b in 0 ..< c - 1 {
        if a * b % c == 1 {
            return b
        }
    }
    fatalError()
}

func applyChineseRemainderTheorem(values: [(value: Int, mod: Int)]) -> Int {
    let product = values.map(\.mod).reduce(1, *)
    return values.map { value, mod in
        let n = product / mod
        let inverse = modularInverse(a: n, c: mod)
        return value * n * inverse
    }.reduce(0, +) % product
}

func normalizeProblem(times: [Int?]) -> [(value: Int, mod: Int)] {
    times.enumerated().compactMap { index, bus in
        guard let bus = bus else { return nil }
        return (value: bus - index, mod: bus)
    }
}

func solve1() {
    var lowestWaitTime = Int.max
    var busId = Int.max

    for time in times.compactMap({ $0 }) {
        let waitTime = (time * ((departure / time) + 1)) - departure
        if waitTime < lowestWaitTime {
            busId = time
            lowestWaitTime = waitTime
        }
    }

    print(busId * lowestWaitTime)
}

func solve2() {
    print(applyChineseRemainderTheorem(values: normalizeProblem(times: times)))
}

solve2()
