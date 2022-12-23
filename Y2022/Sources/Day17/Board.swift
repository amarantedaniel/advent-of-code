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
        for y in position.y..<(position.y + piece.shapes.count) {
            for x in position.x..<(position.x + piece.shapes[y - position.y].count) {
                if y < 0 || x < 0 || y >= grid.count || x >= grid[y].count {
                    return false
                }
                if grid[y][x] == .rock, piece.shapes[y - position.y][x - position.x] == .rock {
                    return false
                }
            }
        }
        return true
    }

    mutating func settle(piece: Piece, at position: Position) -> Int {
        let result = max(getTopPoint() - position.y, 0)
        for y in position.y..<(position.y + piece.shapes.count) {
            for x in position.x..<(position.x + piece.shapes[y - position.y].count) {
                if piece.shapes[y - position.y][x - position.x] == .rock || grid[y][x] == .rock {
                    grid[y][x] = .rock
                } else {
                    grid[y][x] = .empty
                }
            }
        }
        trimExtraLines()
        return result
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

    func getExtraHeightPerColumn() -> [Int] {
        var counts: [Int?] = Array(repeating: nil, count: 7)
        for (index, line) in grid.enumerated() {
            if line == Array(repeating: .empty, count: 7) {
                continue
            }
            for i in 0..<line.count {
                if line[i] == .rock, counts[i] == nil {
                    counts[i] = index
                }
            }
            if !counts.contains(nil) {
                break
            }
        }
        return counts.compactMap { $0 }
    }

    private func getTopPoint() -> Int {
        for (index, line) in grid.enumerated() {
            if line.contains(.rock) {
                return index
            }
        }
        fatalError()
    }
}
