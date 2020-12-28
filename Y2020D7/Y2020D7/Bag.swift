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
        countBags() - 1
    }

    private func countBags() -> Int {
        if bags.isEmpty { return 1 }
        return 1 + bags.values.reduce(0) {
            let (bag, count) = $1
            return $0 + count * bag.countBags()
        }
    }
}
