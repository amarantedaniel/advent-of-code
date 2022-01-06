import Foundation

struct Position {
    let i: Int
    let j: Int

    var window: [Position] {
        var positions: [Position] = []
        for ii in i - 1...i + 1 {
            for jj in j - 1...j + 1 {
                positions.append(Position(i: ii, j: jj))
            }
        }
        return positions
    }

    func isOutOfBounds(in array: [[Int]]) -> Bool {
        return i < 0 || j < 0 || i >= array.count || j >= array[i].count
    }
}
