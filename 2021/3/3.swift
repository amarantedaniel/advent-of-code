import Foundation

let input = try! String(contentsOfFile: "input.txt", encoding: .utf8)

let values = input
    .split(separator: "\n")
    .map(Array.init(_:))

func countOnesAndZeroes(numbers: [[Character]], at index: Int) -> (Int, Int) {
    numbers.reduce((0, 0)) { sums, number in
        let (numberOfOnes, numberOfZeros) = sums
        return number[index] == "1" ? (numberOfOnes + 1, numberOfZeros) : (numberOfOnes, numberOfZeros + 1)
    }
}

func not(_ character: Character) -> Character {
    return character == "0" ? "1" : "0"
}

func calculatRating(in numbers: [[Character]], characterToKeep: Character, index: Int = 0) -> [[Character]] {
    guard numbers.count > 1 else { return numbers }
    let (numberOfOnes, numberOfZeros) = countOnesAndZeroes(numbers: numbers, at: index)
    let character = numberOfOnes >= numberOfZeros ? characterToKeep : not(characterToKeep)
    let filtered = numbers.filter { number in number[index] == character }
    return calculatRating(in: filtered, characterToKeep: characterToKeep, index: index + 1)
}

func toInt(_ number: [Character]) -> UInt {
    UInt(number.map(String.init(_:)).joined(), radix: 2)!
}

let oxygenRating = toInt(calculatRating(in: values, characterToKeep: "0")[0])
let scrubberRating = toInt(calculatRating(in: values, characterToKeep: "1")[0])
print(oxygenRating * scrubberRating)
