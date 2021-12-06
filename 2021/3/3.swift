import Foundation

let input = try! String(contentsOfFile: "input.txt", encoding: .utf8)

let values = input
    .split(separator: "\n")
    .map(Array.init(_:))

enum Rating {
    case oxygen
    case scrubber
}

func calculatRating(in numbers: [[Character]], rating: Rating, index: Int = 0) -> [[Character]] {
    if numbers.count == 1 {
        return numbers
    }
    var numberOfOnes = 0
    var numberOfZeros = 0

    for number in numbers {
        if number[index] == "1" {
            numberOfOnes += 1
        } else {
            numberOfZeros += 1
        }
    }

    let character: Character
    switch rating {
        case .oxygen:
            character = numberOfOnes >= numberOfZeros ? "0" : "1"
        case .scrubber:
            character = numberOfOnes >= numberOfZeros ? "1" : "0"
    }
    let filtered = numbers.filter { number in number[index] == character }
    return calculatRating(in: filtered, rating: rating, index: index + 1)
}

func toInt(_ number: [Character]) -> UInt {
    UInt(number.map(String.init(_:)).joined(), radix: 2)!
}

let oxygenRating = toInt(calculatRating(in: values, rating: .oxygen)[0])
let scrubberRating = toInt(calculatRating(in: values, rating: .scrubber)[0])
print(oxygenRating * scrubberRating)
