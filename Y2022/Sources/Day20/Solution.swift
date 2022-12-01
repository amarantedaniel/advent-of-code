import Foundation

typealias Algorithm = [Int]

func positions(for image: Image) -> [Position] {
    var positions: [Position] = []
    for i in 0..<image.bitmap.count {
        for j in 0..<image.bitmap.count {
            positions.append(Position(i: i, j: j))
        }
    }
    return positions
}

func toggleBit(newImage: inout Image, oldImage: Image, position: Position, algorithm: Algorithm) {
    let number = oldImage.getNumber(at: position)
    let bit = algorithm[number]
    newImage.setBit(bit, at: position)
}

func toggleInfinity(image: inout Image, algorithm: Algorithm) {
    let number = image.getInfinityNumber()
    let bit = algorithm[number]
    image.infinityPixel = bit
}

func solve(input: String, repeating repetitions: Int) -> Int {
    let (algorithm, parsedImage) = Parser.parse(input: input)
    var image = parsedImage.enlarged()
    for _ in 1...repetitions {
        var newImage = image
        let positions = positions(for: newImage)
        for position in positions {
            toggleBit(newImage: &newImage, oldImage: image, position: position, algorithm: algorithm)
        }
        toggleInfinity(image: &newImage, algorithm: algorithm)
        image = newImage.enlarged()
    }

    return image.countLitBits()
}

func solve1(input: String) -> Int {
    return solve(input: input, repeating: 2)
}

func solve2(input: String) -> Int {
    return solve(input: input, repeating: 50)
}
