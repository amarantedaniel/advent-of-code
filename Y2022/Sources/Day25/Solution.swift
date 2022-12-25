import Foundation

private func toInt(snafu character: Character) -> Int {
    switch character {
    case "-":
        return -1
    case "=":
        return -2
    default:
        return character.wholeNumberValue!
    }
}

private func parse(snafu: Substring) -> Int {
    var result = 0
    for (exponent, character) in snafu.reversed().enumerated() {
        result += pow(5, exponent) * toInt(snafu: character)
    }
    return result
}

private func reverse(number: Int) -> String {
    var number = number
    var result = ""
    while number > 0 {
        let remainder = number % 5
        switch remainder {
        case 3:
            number += 2
            result = "=\(result)"
        case 4:
            number += 1
            result = "-\(result)"
        default:
            result = "\(remainder)\(result)"
        }
        number = number / 5
    }
    return result
}

func solve1(input: String) -> String {
    let number = input
        .split(separator: "\n")
        .map(parse(snafu:))
        .reduce(0, +)
    return reverse(number: number)
}

func pow(_ base: Int, _ exponent: Int) -> Int {
    Int(pow(Double(base), Double(exponent)))
}
