func isInvalid(_ number: Int, window: ArraySlice<Int>) -> Bool {
    for first in window {
        for second in window {
            if first + second == number {
                return false
            }
        }
    }
    return true
}

func findInvalidNumber(numbers: [Int], preamble: Int) -> Int? {
    for i in preamble ..< numbers.count {
        let window = numbers[i - preamble ..< i]
        let number = numbers[i]
        if isInvalid(number, window: window) {
            return number
        }
    }
    return nil
}

func findWindow(invalidNumber: Int, numbers: [Int]) -> [Int] {
    for i in 0 ..< numbers.count {
        var window = [numbers[i]]
        var count = numbers[i]
        for j in i + 1 ..< numbers.count {
            count += numbers[j]
            window.append(numbers[j])
            if count == invalidNumber {
                return window
            }
            if count > invalidNumber {
                break
            }
        }
        count = 0
        window = []
    }
    return []
}

public func solve1(_ input: String, preamble: Int = 25) -> Int? {
    let numbers = input.split(separator: "\n").compactMap { Int($0) }
    return findInvalidNumber(numbers: numbers, preamble: preamble)!
}

public func solve2(_ input: String, preamble: Int = 25) -> Int? {
    let numbers = input.split(separator: "\n").compactMap { Int($0) }
    let invalidNumber = findInvalidNumber(numbers: numbers, preamble: preamble)!
    let window = findWindow(invalidNumber: invalidNumber, numbers: numbers)
    return window.max()! + window.min()!
}
