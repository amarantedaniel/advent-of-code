struct Rule {
    let name: String
    let ranges: [Range]
    var validIndexes: [Int] = []

    func isValid(value: Int) -> Bool {
        ranges.contains { $0.contains(number: value) }
    }
}
