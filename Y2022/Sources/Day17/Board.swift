import Foundation

struct Board {
    var grid: [[Shape]]

    init() {
        self.grid = Array(
            repeating: Array(repeating: .empty, count: 7),
            count: 3
        )
        grid.append(Array(repeating: .rock, count: 7))
    }

    mutating func reserveSpace(for piece: Piece) {
        for _ in piece.shapes {
            grid.insert(Array(repeating: .empty, count: 7), at: 0)
        }
    }

    func canMove(position: Position, piece: Piece) -> Bool {
//        print("calling canmove")
//        print("piece: \n\(piece)")
//        print("position: \(position)")
        for y in position.y..<(position.y + piece.shapes.count) {
            for x in position.x..<(position.x + piece.shapes[y - position.y].count) {
                if y < 0 || x < 0 || y >= grid.count || x >= grid[y].count {
                    return false
                }
                if grid[y][x] == .rock && piece.shapes[y - position.y][x - position.x] == .rock {
                    return false
                }
            }
        }
        return true
    }

    mutating func settle(piece: Piece, at position: Position) {
        for y in position.y..<(position.y + piece.shapes.count) {
            for x in position.x..<(position.x + piece.shapes[y - position.y].count) {
                grid[y][x] = piece.shapes[y - position.y][x - position.x]
            }
        }
        trimExtraLines()
    }

    private mutating func trimExtraLines() {
        var count = 0
        for y in 0..<grid.count {
            if grid[y] == Array(repeating: .empty, count: 7) {
                count += 1
            } else {
                break
            }
        }
        if count > 3 {
            grid.removeFirst(count - 3)
        }
    }

    func getHeight() -> Int {
        var count = 0
        for line in grid.reversed() {
            if line != Array(repeating: .empty, count: 7) {
                count += 1
            } else {
                break
            }
        }
        return count - 1
    }
}
