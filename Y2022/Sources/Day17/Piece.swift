import Foundation

enum Shape: String {
    case rock = "#"
    case empty = "."
}

struct Piece {
    let shapes: [[Shape]]

    func prepending(other: [Shape]) -> [[Shape]] {
        var newShapes: [[Shape]] = []
        for line in shapes {
            newShapes.append(other + line)
        }
        return newShapes
    }

    static let horizontal = Piece(
        shapes: [
            [.rock, .rock, .rock, .rock]
        ]
    )

    static let cross = Piece(
        shapes: [
            [.empty, .rock, .empty],
            [.rock, .rock, .rock],
            [.empty, .rock, .empty]
        ]
    )

    static let corner = Piece(
        shapes: [
            [.empty, .empty, .rock],
            [.empty, .empty, .rock],
            [.rock, .rock, .rock]
        ]
    )

    static let vertical = Piece(
        shapes: [
            [.rock],
            [.rock],
            [.rock],
            [.rock]
        ]
    )

    static let square = Piece(
        shapes: [
            [.rock, .rock],
            [.rock, .rock],
        ]
    )
}
