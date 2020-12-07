import Foundation

struct Parser {
    func parse(input: String) -> [(String, [String: Int])] {
        return input.split(separator: "\n").map(parseRule(input:))
    }

    private func parseRule(input: String.SubSequence) -> (String, [String: Int]) {
        let info = input.components(separatedBy: " bags contain ")
        let bag = info[0]
        let innerBags = info[1]
            .components(separatedBy: ", ")
            .reduce(into: [String: Int]()) { dict, data in
                let values = data.split(separator: " ")
                if let number = Int(values[0]) {
                    let name = values[1 ... 2].joined(separator: " ")
                    dict[name] = number
                }
            }
        return (bag, innerBags)
    }

    func buildBagGraph(input: [(String, [String: Int])], startingPoint: String) -> Bag {
        var bags: [Bag] = []
        for (bagName, bagsInside) in input {
            let bag = getOrInsertBag(name: bagName, bags: &bags)
            for (key, value) in bagsInside {
                let innerBag = getOrInsertBag(name: key, bags: &bags)
                bag.append(bag: innerBag, count: value)
            }
        }
        return bags.first { $0.name == startingPoint }!
    }

    private func getOrInsertBag(name: String, bags: inout [Bag]) -> Bag {
        if let bag = bags.first(where: { $0.name == name }) {
            return bag
        }
        let bag = Bag(name: name)
        bags.append(bag)
        return bag
    }
}

func countBagsThatCanHold(bag: String, bags: [(String, [String: Int])]) -> Int {
    var remainingBags = [bag]
    var result: Set<String> = []

    while !remainingBags.isEmpty {
        let bag = remainingBags.removeFirst()
        bags
            .filter { _, dictionary in dictionary[bag] != nil }
            .map { name, _ in name }
            .forEach {
                if !result.contains($0) {
                    remainingBags.append($0)
                }
                result.insert($0)
            }
    }
    return result.count
}

class Bag {
    let name: String
    var bags: [String: (Bag, Int)] = [:]

    init(name: String) {
        self.name = name
    }

    func append(bag: Bag, count: Int) {
        bags[bag.name] = (bag, count)
    }

    func countInnerBags() -> Int {
        return countBags() - 1
    }

    private func countBags() -> Int {
        if bags.isEmpty { return 1 }
        return 1 + bags.values.reduce(0) {
            let (bag, count) = $1
            return $0 + count * bag.countBags()
        }
    }
}

let input = try! String(contentsOfFile: "input.txt", encoding: .utf8)
let parser = Parser()
let bags = parser.parse(input: input)
print(countBagsThatCanHold(bag: "shiny gold", bags: bags))
print(parser.buildBagGraph(input: bags, startingPoint: "shiny gold").countInnerBags())
