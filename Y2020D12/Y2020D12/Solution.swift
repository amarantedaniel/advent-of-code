public func solve1(_ input: String) -> Int {
    let actions = Parser.parse(input: input)
    var ship = DirectionShip()
    for action in actions {
        ship.move(action: action)
    }
    return abs(ship.position.x) + abs(ship.position.y)
}

public func solve2(_ input: String) -> Int {
    let actions = Parser.parse(input: input)
    var ship = WaypointShip()
    for action in actions {
        ship.move(action: action)
    }
    return abs(ship.position.x) + abs(ship.position.y)
}
