
func find1(values: [Int], sum: Int) -> Int? {
    for elem1 in values {
        for elem2 in values {
            if elem1 + elem2 == sum {
                return elem1 * elem2
            }
        }
    }
    return nil
}

func find2(values: [Int], sum: Int) -> Int? {
    for elem1 in values {
        for elem2 in values {
            for elem3 in values {
                if elem1 + elem2 + elem3 == sum {
                    return elem1 * elem2 * elem3
                }
            }
        }
    }
    return nil
}

func parse(input: String) -> [Int] {
    input
        .split(separator: "\n")
        .compactMap { Int($0) }
}

public func solve1(_ input: String) -> Int? {
    find1(values: parse(input: input), sum: 2020)
}

public func solve2(_ input: String) -> Int? {
    find2(values: parse(input: input), sum: 2020)
}
