protocol Position {
    func adjacents() -> [Self]
}

struct Position3D: Position, Hashable, Comparable {
    let x: Int
    let y: Int
    let z: Int

    func adjacents() -> [Position3D] {
        var positions: [Position3D] = []
        let range = [-1, 0, 1]
        for x in range {
            for y in range {
                for z in range {
                    if !(x == 0 && y == 0 && z == 0) {
                        positions.append(
                            Position3D(x: self.x + x, y: self.y + y, z: self.z + z)
                        )
                    }
                }
            }
        }
        return positions
    }

    static func < (lhs: Position3D, rhs: Position3D) -> Bool {
        guard lhs.z == rhs.z else { return lhs.z < rhs.z }
        guard lhs.y == rhs.y else { return lhs.y < rhs.y }
        return lhs.x < rhs.x
    }
}

struct Position4D: Position, Hashable, Comparable {
    let x: Int
    let y: Int
    let z: Int
    let w: Int

    func adjacents() -> [Position4D] {
        var positions: [Position4D] = []
        let range = [-1, 0, 1]
        for x in range {
            for y in range {
                for z in range {
                    for w in range {
                        if !(x == 0 && y == 0 && z == 0 && w == 0) {
                            positions.append(
                                Position4D(x: self.x + x, y: self.y + y, z: self.z + z, w: self.w + w)
                            )
                        }
                    }
                }
            }
        }
        return positions
    }

    static func < (lhs: Position4D, rhs: Position4D) -> Bool {
        guard lhs.w == rhs.w else { return lhs.w < rhs.w }
        guard lhs.z == rhs.z else { return lhs.z < rhs.z }
        guard lhs.y == rhs.y else { return lhs.y < rhs.y }
        return lhs.x < rhs.x
    }
}
