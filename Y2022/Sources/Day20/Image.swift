import Foundation

struct Image {
    var bitmap: [[Int]]
    var infinityPixel = 0

    var width: Int { bitmap[0].count }
    var height: Int { bitmap.count }

    func enlarged() -> Image {
        let newBitmap: [[Int]] = bitmap.map { line in
            let padding = Array(repeating: infinityPixel, count: 2)
            return padding + line + padding
        }
        let infinityLine = Array(repeating: infinityPixel, count: width + 4)
        let padding = Array(repeating: infinityLine, count: 2)
        return Image(bitmap: padding + newBitmap + padding, infinityPixel: infinityPixel)
    }

    func getNumber(at position: Position) -> Int {
        let bits = position.window.reduce(into: [Int]()) { bits, position in
            if position.isOutOfBounds(in: bitmap) {
                bits.append(infinityPixel)
            } else {
                bits.append(bitmap[position.i][position.j])
            }
        }
        return bits.binaryToInt()
    }

    func getInfinityNumber() -> Int {
        return Array(repeating: infinityPixel, count: 8).binaryToInt()
    }

    func countLitBits() -> Int {
        return bitmap.flatMap { $0.filter(\.isLit) }.count
    }

    mutating func setBit(_ bit: Int, at position: Position) {
        bitmap[position.i][position.j] = bit
    }
}

extension Image: CustomStringConvertible {
    var description: String {
        bitmap.reduce("") { "\($0)\n\($1.map(\.image).joined())" }
    }
}

private extension Int {

    var isLit: Bool {
        switch self {
        case 1: return true
        case 0: return false
        default: fatalError()
        }
    }

    var image: String {
        switch self {
        case 1: return "#"
        case 0: return "."
        default: fatalError()
        }
    }
}

private extension Array where Element == Int {
    func binaryToInt() -> Int {
        Int(self.map(String.init(_:)).joined(), radix: 2)!
    }
}
