import Foundation

func parse(input: Substring) -> [Any] {
    var input = input
    var arrays: [[Any]] = [[]]
    while !input.isEmpty {
        let character = input.removeFirst()
        switch character {
        case "[":
            arrays.append([])
        case "]":
            let last = arrays.removeLast()
            arrays[arrays.count - 1].append(last)
        case ",":
            break
        default:
            var number = character.wholeNumberValue!
            while input.first!.isWholeNumber {
                number += number * 10 + input.removeFirst().wholeNumberValue!
            }
            arrays[arrays.count - 1].append(number)
        }
    }
    return arrays[0]
}

enum Sorting {
    case sorted
    case notSorted
    case same
}

private func compare(left: Int, right: Int) -> Sorting {
    if left < right {
        return .sorted
    }
    if left > right {
        return .notSorted
    }
    return .same
}

private func compare(left: [Any], right: [Any]) -> Sorting {
    var i = 0
    while true {
        if i >= left.count, i >= right.count {
            return .same
        }
        if i >= left.count {
            return .sorted
        }
        if i >= right.count {
            return .notSorted
        }
        var sorting: Sorting = .same
        switch (left[i], right[i]) {
        case let (lhs as Int, rhs as Int):
            sorting = compare(left: lhs, right: rhs)
        case let (lhs as [Any], rhs as Int):
            sorting = compare(left: lhs, right: [rhs])
        case let (lhs as Int, rhs as [Any]):
            sorting = compare(left: [lhs], right: rhs)
        case let (lhs as [Any], rhs as [Any]):
            sorting = compare(left: lhs, right: rhs)
        default:
            break
        }
        if sorting == .sorted || sorting == .notSorted {
            return sorting
        }
        i += 1
    }
}

func solve1(input: String) -> Int {
    let components = input.components(separatedBy: "\n\n")
    var result = 0
    for (index, component) in components.enumerated() {
        let elements = component.split(separator: "\n")
        let left = parse(input: elements[0])
        let right = parse(input: elements[1])
        if case .sorted = compare(left: left, right: right) {
            result += index + 1
        }
    }
    return result
}

func solve2(input: String) -> Int {
    var packets = input
        .components(separatedBy: "\n\n")
        .flatMap { $0.split(separator: "\n") }
        .map(parse(input:))
    packets.append([[2]])
    packets.append([[6]])
    let sorted = packets.sorted { lhs, rhs in
        compare(left: lhs, right: rhs) == .sorted
    }
    var result = 1
    for (index, packet) in sorted.enumerated() {
        if packet as? [[Int]] == [[2]] || packet as? [[Int]] == [[6]] {
            result *= index + 1
        }
    }
    return result
}
