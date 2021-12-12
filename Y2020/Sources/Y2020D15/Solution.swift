func solve(_ input: String, limit: Int) -> Int {
    let numbers = input.split(separator: ",").compactMap { Int($0) }

    var dict: [Int: Int] = [:]
    for (index, number) in numbers.enumerated() {
        dict[number] = index
    }

    var current = 0
    for index in numbers.count ..< limit - 1 {
        if let lastIndex = dict[current] {
            dict[current] = index
            current = index - lastIndex
        } else {
            dict[current] = index
            current = 0
        }
    }

    return current
}

public func solve1(_ input: String) -> Int {
    solve(input, limit: 2020)
}

public func solve2(_ input: String) -> Int {
    solve(input, limit: 30_000_000)
}
