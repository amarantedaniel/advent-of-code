import Foundation

extension Set {
    mutating func pop(where block: (Element) -> Bool) -> Element? {
        guard let element = first(where: block) else { return nil }
        remove(element)
        return element
    }
}

struct Signal {
    let patterns: Set<Set<Character>>
    let outputs: [Set<Character>]
}

func parse(input: String) -> [Signal] {
    var signals: [Signal] = []
    for line in input.split(separator: "\n") {
        let splitted = line.components(separatedBy: " | ")
        let patterns = splitted[0].components(separatedBy: " ").map { Set($0) }
        let outputs = splitted[1].components(separatedBy: " ").map { Set($0) }
        signals.append(Signal(patterns: Set(patterns), outputs: outputs))
    }
    return signals
}

func solve2(input: String) -> Int {
    let signals = parse(input: input)
    var sum = 0

    for signal in signals {
        var patterns = signal.patterns
        let outputs = signal.outputs
        var lookup: [Set<Character>: Int] = [:]

        let one = patterns.pop(where: { $0.count == 2 })!
        lookup[one] = 1
        let four = patterns.pop(where: { $0.count == 4 })!
        lookup[four] = 4
        let seven = patterns.pop(where: { $0.count == 3 })!
        lookup[seven] = 7
        let eight = patterns.pop(where: { $0.count == 7 })!
        lookup[eight] = 8
        let nine = patterns.pop(where: { $0.isStrictSuperset(of: four) && $0.count == 6 })!
        lookup[nine] = 9
        let zero = patterns.pop(where: { $0 != nine && $0.count == 6 && $0.isStrictSuperset(of: one) })!
        lookup[zero] = 0
        let six = patterns.pop(where: { $0 != nine && $0 != zero && $0.count == 6 })!
        lookup[six] = 6
        let two = patterns.pop(where: { !$0.isStrictSubset(of: nine) })!
        lookup[two] = 2
        let three = patterns.pop(where: { $0.isStrictSuperset(of: one) })!
        lookup[three] = 3
        let five = patterns.popFirst()!
        lookup[five] = 5

        sum += outputs
            .compactMap { lookup[$0] }
            .reduce(0) { result, number in
                (result * 10) + number
            }
    }
    return sum
}
