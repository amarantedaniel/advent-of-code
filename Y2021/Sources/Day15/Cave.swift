import Foundation

typealias Cave = [[Int]]

extension Cave {

    var lastCoordinate: Coordinate {
        let i = count - 1
        let j = self[i].count - 1
        return Coordinate(i: i, j: j)
    }

    func coordinates() -> [Coordinate] {
        var coordinates: [Coordinate] = []
        for i in 0..<self.count {
            for j in 0..<self[i].count {
                coordinates.append(Coordinate(i: i, j: j))
            }
        }
        return coordinates
    }

    func neighboors(from coordinate: Coordinate) -> [Coordinate] {
        let i = coordinate.i
        let j = coordinate.j
        var coordinates: [Coordinate] = []
        for ii in Swift.max(i - 1, 0)...Swift.min(i + 1, self.count - 1) {
            for jj in Swift.max(j - 1, 0)...Swift.min(j + 1, self[ii].count - 1) where (i == ii || j == jj) && !(i == ii && j == jj) {
                coordinates.append(Coordinate(i: ii, j: jj))
            }
        }
        return coordinates
    }

    func get(_ coordinate: Coordinate) -> Int {
        return self[coordinate.i][coordinate.j]
    }

    var formatted: String {
        return self
            .map { $0.map(\.description).joined() }
            .joined(separator: "\n")
    }
}
