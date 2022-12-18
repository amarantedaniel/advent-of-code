import Foundation

extension Piece: CustomStringConvertible {
    var description: String {
        format(grid: shapes)
    }
}

extension Board: CustomStringConvertible {
    var description: String {
        format(grid: grid)
    }

    func display(piece: Piece, position: Position) -> String {
        var grid = grid
        for y in position.y..<(position.y + piece.shapes.count) {
            for x in position.x..<(position.x + piece.shapes[y - position.y].count) {
                grid[y][x] = piece.shapes[y - position.y][x - position.x]
            }
        }
        return format(grid: grid)
    }
}

private func format(grid: [[Shape]]) -> String {
    grid
        .map { $0.map(\.rawValue).joined() }
        .joined(separator: "\n")
}

extension Array where Element == [Shape] {
    var formatted: String {
        format(grid: self)
    }
}
