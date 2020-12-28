enum GraphBuilder {
    static func buildBagGraph(input: [(String, [String: Int])], startingPoint: String) -> Bag {
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

    private static func getOrInsertBag(name: String, bags: inout [Bag]) -> Bag {
        if let bag = bags.first(where: { $0.name == name }) {
            return bag
        }
        let bag = Bag(name: name)
        bags.append(bag)
        return bag
    }
}
