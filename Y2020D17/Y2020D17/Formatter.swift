enum Formatter {
    static func format(positions: Set<Position3D>) -> String {
        let minX = positions.map(\.x).min()!
        let maxX = positions.map(\.x).max()!

        let minY = positions.map(\.y).min()!
        let maxY = positions.map(\.y).max()!

        var string = ""
        for y in minY ... maxY {
            for x in minX ... maxX {
                if positions.contains(Position3D(x: x, y: y, z: 0)) {
                    string += "#"
                } else {
                    string += "."
                }
            }
            string += "\n"
        }
        return string
    }
}
