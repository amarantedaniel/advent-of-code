import AdventOfCode
import Foundation

struct Point: Hashable, CustomStringConvertible {
    let x, y, z: Int

    var description: String {
        "(x: \(x), y: \(y), z: \(z))"
    }
}

struct Pair: Hashable {
    let p1: Point
    let p2: Point
}

struct Day08: AdventDay {
    private func distance(p1: Point, p2: Point) -> Int {
        let a = pow(Double(p1.x - p2.x), 2)
        let b = pow(Double(p1.y - p2.y), 2)
        let c = pow(Double(p1.z - p2.z), 2)
        return Int(sqrt(a + b + c))
    }

    func part1(input: String) throws -> Int {
        var closest: [Pair: Int] = [:]
        let points = input
            .split(separator: "\n")
            .map { $0.split(separator: ",").map { Int($0)! } }
            .map { Point(x: $0[0], y: $0[1], z: $0[2]) }
        for p1 in points {
            for p2 in points where p1 != p2 {
                if closest[Pair(p1: p2, p2: p1)] == nil {
                    closest[Pair(p1: p1, p2: p2)] = distance(p1: p1, p2: p2)
                }
            }
        }
        let sorted = closest.sorted(by: { $0.value < $1.value })
        var circuits: [Set<Point>] = []
        for i in 0..<1000 {
            let (pair, _) = sorted[i]
            var c1: Int?
            var c2: Int?
            for j in 0..<circuits.count {
                if circuits[j].contains(pair.p1) {
                    c1 = j
                }
                if circuits[j].contains(pair.p2) {
                    c2 = j
                }
            }
            if let c1, let c2 {
                if c1 != c2 {
                    circuits[c1].formUnion(circuits[c2])
                    circuits.remove(at: c2)
                }
            } else if let c1 {
                circuits[c1].insert(pair.p2)
            } else if let c2 {
                circuits[c2].insert(pair.p1)
            } else {
                circuits.append([pair.p1, pair.p2])
            }
//            print()
//            for circuit in circuits {
//                print(circuit)
//            }
//            print()
        }
//        for circuit in circuits {
//            print(circuit.count)
//        }
        return circuits
            .map(\.count)
            .sorted(by: >)
            .prefix(3)
            .reduce(1, *)
    }

    func part2(input: String) throws -> Int {
        var closest: [Pair: Int] = [:]
        let points = input
            .split(separator: "\n")
            .map { $0.split(separator: ",").map { Int($0)! } }
            .map { Point(x: $0[0], y: $0[1], z: $0[2]) }
        for p1 in points {
            for p2 in points where p1 != p2 {
                if closest[Pair(p1: p2, p2: p1)] == nil {
                    closest[Pair(p1: p1, p2: p2)] = distance(p1: p1, p2: p2)
                }
            }
        }
        let sorted = closest.sorted(by: { $0.value < $1.value })
        var circuits: [Set<Point>] = []
        for i in 0..<Int.max {
            let (pair, _) = sorted[i]
            var c1: Int?
            var c2: Int?
            for j in 0..<circuits.count {
                if circuits[j].contains(pair.p1) {
                    c1 = j
                }
                if circuits[j].contains(pair.p2) {
                    c2 = j
                }
            }
            if let c1, let c2 {
                if c1 != c2 {
                    circuits[c1].formUnion(circuits[c2])
                    circuits.remove(at: c2)
                }
            } else if let c1 {
                circuits[c1].insert(pair.p2)
            } else if let c2 {
                circuits[c2].insert(pair.p1)
            } else {
                circuits.append([pair.p1, pair.p2])
            }
            if circuits.count == 1, circuits.first?.count == points.count {
                return pair.p1.x * pair.p2.x
            }
        }
        fatalError()
    }
}
