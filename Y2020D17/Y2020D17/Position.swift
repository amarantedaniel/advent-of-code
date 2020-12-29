struct Position: Hashable, Comparable {
    let x: Int
    let y: Int
    let z: Int

    func adjacents() -> [Position] {
        var positions: [Position] = []
        let range = [-1, 0, 1]
        for x in range {
            for y in range {
                for z in range {
                    if !(x == 0 && y == 0 && z == 0) {
                        positions.append(
                            Position(x: self.x + x, y: self.y + y, z: self.z + z)
                        )
                    }
                }
            }
        }
        return positions
    }

    static func < (lhs: Position, rhs: Position) -> Bool {
        guard lhs.z == rhs.z else { return lhs.z < rhs.z }
        guard lhs.y == rhs.y else { return lhs.y < rhs.y }
        return lhs.x < rhs.x
    }
}
