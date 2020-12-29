struct DirectionShip {
    var position = Position(x: 0, y: 0)
    private var direction = Direction.east

    mutating func move(action: Action) {
        switch action {
        case let .north(value):
            position.y += value
        case let .south(value):
            position.y -= value
        case let .east(value):
            position.x += value
        case let .west(value):
            position.x -= value
        case let .forward(value):
            switch direction {
            case .north:
                position.y += value
            case .south:
                position.y -= value
            case .east:
                position.x += value
            case .west:
                position.x -= value
            }
        case let .right(value):
            direction = direction.turnRight(degrees: value)
        case let .left(value):
            direction = direction.turnLeft(degrees: value)
        }
    }

    private enum Direction: CaseIterable {
        case north
        case east
        case south
        case west

        func turnRight(degrees: Int) -> Direction {
            turn(degrees: degrees, allCases: Direction.allCases)
        }

        func turnLeft(degrees: Int) -> Direction {
            turn(degrees: degrees, allCases: Array(Direction.allCases.reversed()))
        }

        private func turn(degrees: Int, allCases: [Direction]) -> Direction {
            let turns = degrees / 90
            let index = allCases.firstIndex(of: self)!
            return allCases[(index + turns) % allCases.count]
        }
    }
}
