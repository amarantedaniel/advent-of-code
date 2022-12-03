import Foundation

private func getRepeatedItemsInSameBag(input: String) -> [Character] {
    let lines = input
        .split(separator: "\n")
        .map { Array($0) }
    return lines.map { line in
        let firstPart = Set(line[0..<line.count / 2])
        let secondPart = Set(line[line.count / 2..<line.count])
        return firstPart.intersection(secondPart).first!
    }
}

private func getRepeatedItemsInGroup(input: String) -> [Character] {
    let lines = input
        .split(separator: "\n")
        .map { Set($0) }
    var result: [Character] = []
    for index in stride(from: 0, to: lines.count, by: 3) {
        let characters = lines[index + 1..<index + 3].reduce(lines[index]) {
            $0.intersection($1)
        }
        result.append(characters.first!)
    }
    return result
}

private func getValue(from character: Character) -> UInt {
    let asciiValue = UInt(character.asciiValue!)
    let shift: UInt = character.isUppercase ? 38 : 96
    return asciiValue - shift
}

func solve1(input: String) -> UInt {
    getRepeatedItemsInSameBag(input: input)
        .reduce(0) { $0 + getValue(from: $1) }
}

func solve2(input: String) -> UInt {
    getRepeatedItemsInGroup(input: input)
        .reduce(0) { $0 + getValue(from: $1) }
}
