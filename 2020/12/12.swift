import Foundation

typealias Position = (x: Int, y: Int)

enum Action {
    case north(Int)
    case south(Int)
    case east(Int)
    case west(Int)
    case left(Int)
    case right(Int)
    case forward(Int)

    init?(text: Substring) {
        switch (text.first, Int(text.dropFirst())) {
        case let ("N", value?):
            self = .north(value)
        case let ("S", value?):
            self = .south(value)
        case let ("E", value?):
            self = .east(value)
        case let ("W", value?):
            self = .west(value)
        case let ("R", value?):
            self = .right(value)
        case let ("L", value?):
            self = .left(value)
        case let ("F", value?):
            self = .forward(value)
        default:
            return nil
        }
    }
}

struct Ship {
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

let input = try! String(contentsOfFile: "input.txt", encoding: .utf8)
let actions = input.split(separator: "\n").compactMap(Action.init(text:))
var ship = Ship()
var waypointShip = WaypointShip()
for action in actions {
    ship.move(action: action)
    waypointShip.move(action: action)
}

print(abs(ship.position.x) + abs(ship.position.y))
print(abs(waypointShip.position.x) + abs(waypointShip.position.y))
