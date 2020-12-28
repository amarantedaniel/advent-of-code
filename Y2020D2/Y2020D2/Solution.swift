import Foundation

public func solve1(_ input: String) -> Int {
    return Parser.parse(input: input)
        .filter { password, policy in policy.validateMinMax(password: password) }
        .count
}

public func solve2(_ input: String) -> Int {
    return Parser.parse(input: input)
        .filter { password, policy in policy.validatePositions(password: password) }
        .count
}
