import Foundation

typealias MonkeyID = Int
typealias Item = Int

struct Monkey {
    let id: MonkeyID
    var items: [Item]
    let operation: (Item) -> Item
    let throwTo: (Item) -> MonkeyID
    var inspected = 0
}

func execute(index: Int, monkeys: inout [Monkey], minimize: (Int) -> Int) {
    while !monkeys[index].items.isEmpty {
        let item = monkeys[index].items.removeFirst()
        monkeys[index].inspected += 1
        let updated = minimize(monkeys[index].operation(item))
        let newMonkey = monkeys[index].throwTo(updated)
        monkeys[newMonkey].items.append(updated)
    }
}

func solve1(input: String) -> Int {
    var monkeys = Parser.parse(input: input)
    for _ in 0..<20 {
        for i in 0..<monkeys.count {
            execute(index: i, monkeys: &monkeys, minimize: { $0 / 3 })
        }
    }
    let sorted = monkeys.map(\.inspected).sorted()
    return sorted[monkeys.count - 1] * sorted[monkeys.count - 2]
}

func solve2(input: String) -> Int {
    var monkeys = Parser.parse(input: input)
    for _ in 0..<10000 {
        for i in 0..<monkeys.count {
            execute(index: i, monkeys: &monkeys, minimize: { $0 % 9699690 })
        }
    }
    let sorted = monkeys.map(\.inspected).sorted()
    return sorted[monkeys.count - 1] * sorted[monkeys.count - 2]
}
