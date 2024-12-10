import AdventOfCode

struct Day03: AdventDay {
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

    func part1(input: String) throws -> UInt {
        throw AdventError.notImplemented
    }

    func part2(input: String) throws -> UInt {
        let values = input.split(separator: "\n").map(Array.init(_:))
        let oxygenRating = toInt(calculatRating(in: values, characterToKeep: "0")[0])
        let scrubberRating = toInt(calculatRating(in: values, characterToKeep: "1")[0])
        return oxygenRating * scrubberRating
    }
}
