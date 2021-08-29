struct WaypointShip {
    var position = Position(x: 0, y: 0)
    private var waypoint = Waypoint()

    mutating func move(action: Action) {
        switch action {
        case let .north(value):
            waypoint.position.y += value
        case let .south(value):
            waypoint.position.y -= value
        case let .east(value):
            waypoint.position.x += value
        case let .west(value):
            waypoint.position.x -= value
        case let .forward(value):
            position.x += value * waypoint.position.x
            position.y += value * waypoint.position.y
        case let .right(value):
            waypoint.rotateRight(degrees: value)
        case let .left(value):
            waypoint.rotateLeft(degrees: value)
        }
    }

    private struct Waypoint {
        var position = Position(x: 10, y: 1)

        mutating func rotateRight(degrees: Int) {
            let turns = degrees / 90
            for _ in 0 ..< turns {
                position = Position(x: position.y, y: -position.x)
            }
        }

        mutating func rotateLeft(degrees: Int) {
            let turns = degrees / 90
            for _ in 0 ..< turns {
                position = Position(x: -position.y, y: position.x)
            }
        }
    }
}
