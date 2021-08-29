func solve1(_ input: String) -> Int {
    Parser.parse(input: input)
        .filter { $0.validateRequired() }
        .count
}

func solve2(_ input: String) -> Int {
    Parser.parse(input: input)
        .filter { $0.validate() }
        .count
}
