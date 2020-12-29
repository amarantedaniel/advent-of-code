enum Parser {
    static func parse(input: String) -> Set<Position> {
        let matrix = input.split(separator: "\n").map { Array($0) }
        var cubes: Set<Position> = []

        for i in 0 ..< matrix.count {
            for j in 0 ..< matrix[i].count {
                if matrix[i][j] == "#" {
                    cubes.insert(Position(x: j, y: i, z: 0))
                }
            }
        }
        return cubes
    }
}

func run(positions: Set<Position>) -> Set<Position> {
    var newPositions: Set<Position> = []
    for position in positions {
        let adjacents = position.adjacents()
        let activeAdjacents = positions.intersection(adjacents)
        let inactiveAdjacents = Set(adjacents).subtracting(positions)
        if 2...3 ~= activeAdjacents.count {
            newPositions.insert(position)
        }
        for adjacent in inactiveAdjacents {
            let adjacents = adjacent.adjacents()
            let activeAdjacents = positions.intersection(adjacents)
            if activeAdjacents.count == 3 {
                newPositions.insert(adjacent)
            }
        }
    }

    return newPositions
}

public func solve1(_ input: String) -> Int {
    let positions = Parser.parse(input: input)
    let first = run(positions: positions)
    let second = run(positions: first)
    let third = run(positions: second)
    let fourth = run(positions: third)
    let fifth = run(positions: fourth)
    let sixth = run(positions: fifth)

    return sixth.count
}
