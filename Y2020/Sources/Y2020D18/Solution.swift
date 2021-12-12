import Foundation

func firstRangeOf(text: String, matching regex: String) -> Range<String.Index>? {
    let regex = try! NSRegularExpression(pattern: regex)
    let results = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
    return results.compactMap { Range($0.range, in: text) }.first
}

func solve(operation: Substring) -> UInt64 {
    let elements = operation.split(separator: " ")
    switch elements[1] {
    case "+":
        return UInt64(elements[0])! + UInt64(elements[2])!
    case "*":
        return UInt64(elements[0])! * UInt64(elements[2])!
    default:
        fatalError()
    }
}

func solveIgnoringPrecedence(input: String) -> UInt64 {
    var input = input
    if let range = firstRangeOf(text: input, matching: "\\(([0-9+* ]+)\\)") {
        let substring = input[input.index(after: range.lowerBound) ..< input.index(before: range.upperBound)]
        let result = solveIgnoringPrecedence(input: String(substring))
        input.replaceSubrange(range, with: "\(result)")
        return solveIgnoringPrecedence(input: input)
    }
    if let range = firstRangeOf(text: input, matching: "[0-9]+ [+*] [0-9]+") {
        let result = solve(operation: input[range])
        input.replaceSubrange(range, with: "\(result)")
        return solveIgnoringPrecedence(input: input)
    }
    return UInt64(input)!
}

func solveWithPrecedence(input: String) -> UInt64 {
    var input = input
    if let range = firstRangeOf(text: input, matching: "\\(([0-9+* ]+)\\)") {
        let substring = input[range].dropFirst().dropLast()
        let result = solveWithPrecedence(input: String(substring))
        input.replaceSubrange(range, with: "\(result)")
        return solveWithPrecedence(input: input)
    }
    if let range = firstRangeOf(text: input, matching: "[0-9]+ \\+ [0-9]+") {
        let result = solve(operation: input[range])
        input.replaceSubrange(range, with: "\(result)")
        return solveWithPrecedence(input: input)
    }
    if let range = firstRangeOf(text: input, matching: "[0-9]+ \\* [0-9]+") {
        let result = solve(operation: input[range])
        input.replaceSubrange(range, with: "\(result)")
        return solveWithPrecedence(input: input)
    }
    return UInt64(input)!
}

public func solve1(_ input: String) -> UInt64 {
    return input.split(separator: "\n").reduce(0) {
        $0 + solveIgnoringPrecedence(input: String($1))
    }
}

public func solve2(_ input: String) -> UInt64 {
    return input.split(separator: "\n").reduce(0) {
        $0 + solveWithPrecedence(input: String($1))
    }
}
