enum Parser {

    static func parse<P: Position & Hashable>(input: String, buildPosition: ((Int, Int) -> P)) -> Set<P> {
        let matrix = input.split(separator: "\n").map { Array($0) }
        var cubes: Set<P> = []

        for i in 0 ..< matrix.count {
            for j in 0 ..< matrix[i].count {
                if matrix[i][j] == "#" {
                    cubes.insert(buildPosition(j, i))
                }
            }
        }
        return cubes
    }
}
