func run<P: Position & Hashable>(positions: Set<P>) -> Set<P>  {
    var newPositions: Set<P> = []
    for position in positions {
        let adjacents = position.adjacents()
        let activeAdjacents = positions.intersection(adjacents)
        let inactiveAdjacents = Set(adjacents).subtracting(positions)
        if 2 ... 3 ~= activeAdjacents.count {
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

func run<P: Position & Hashable>(positions: Set<P>, iterations: Int) -> Set<P> {
    var positions = positions
    for _ in 0 ..< iterations {
        positions = run(positions: positions)
    }
    return positions
}

public func solve1(_ input: String) -> Int {
    let positions = Parser.parse(input: input) { (x, y) in
        Position3D(x: x, y: y, z: 0)
    }
    return run(positions: positions, iterations: 6).count
}

public func solve2(_ input: String) -> Int {
    let positions = Parser.parse(input: input) { (x, y) in
        Position4D(x: x, y: y, z: 0, w: 0)
    }
    return run(positions: positions, iterations: 6).count
}
