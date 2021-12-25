import Foundation

typealias Matrix = [[Int]]
typealias Coordinate = (i: Int, j: Int)

extension Matrix {
    var formatted: String {
        return self
            .map { $0.map(\.description).joined() }
            .joined(separator: "\n")
    }

    func neighboors(coordinate: Coordinate) -> [Coordinate] {
        let (i, j) = coordinate
        var coordinates: [Coordinate] = []
        for ii in Swift.max(i - 1, 0)...Swift.min(i + 1, self.count - 1) {
            for jj in Swift.max(j - 1, 0)...Swift.min(j + 1, self[ii].count - 1) where i != ii || j != jj {
                coordinates.append((i: ii, j: jj))
            }
        }
        return coordinates
    }

    func forEach(block: (Coordinate) -> Void) {
        for i in 0..<self.count {
            for j in 0..<self[i].count {
                block(Coordinate(i: i, j: j))
            }
        }
    }

    func get(_ coordinate: Coordinate) -> Int {
        return self[coordinate.i][coordinate.j]
    }

    mutating func set(_ value: Int, at coordinate: Coordinate) {
        self[coordinate.i][coordinate.j] = value
    }

    mutating func increment(_ coordinate: Coordinate) {
        self[coordinate.i][coordinate.j] += 1
    }
}
