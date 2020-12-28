import Foundation

enum Seat: Character {
    case floor = "."
    case empty = "L"
    case occupied = "#"

    var isOccupied: Bool {
        self == .occupied
    }
}

struct Layout: Equatable {
    private typealias Coordinate = (i: Int, j: Int)
    private typealias Direction = (i: Int, j: Int)
    private var seats: [[Seat]]

    init(seats: [[Seat]]) {
        self.seats = seats
    }

    init(input: String) {
        seats = input.split(separator: "\n").map {
            $0.compactMap(Seat.init(rawValue:))
        }
    }

    func run() -> Layout {
        var newSeats = seats
        for i in 0 ..< seats.count {
            for j in 0 ..< seats[i].count {
                let adjacentSeats = getAdjacentSeats(for: Coordinate(i: i, j: j))
                let occupiedSeats = adjacentSeats.filter(\.isOccupied)
                switch seats[i][j] {
                case .empty where occupiedSeats.isEmpty:
                    newSeats[i][j] = .occupied
                case .occupied where occupiedSeats.count >= 5:
                    newSeats[i][j] = .empty
                default:
                    break
                }
            }
        }
        return Layout(seats: newSeats)
    }

    private func getAdjacentSeats(for coordinate: Coordinate) -> [Seat] {
        var adjacentSeats = [Seat]()
        for i in -1 ... 1 {
            for j in -1 ... 1 {
                if i == 0, j == 0 { continue }
                let origin = Coordinate(i: coordinate.i, j: coordinate.j)
                let direction = Direction(i: i, j: j)
                if let seat = findSeat(from: origin, direction: direction) {
                    adjacentSeats.append(seat)
                }
            }
        }
        return adjacentSeats
    }

    private func findSeat(from: Coordinate, direction: Direction) -> Seat? {
        let i = from.i + direction.i
        let j = from.j + direction.j
        guard seats.indices.contains(i), seats[i].indices.contains(j) else { return nil }
        let seat = seats[i][j]
        switch seat {
        case .floor:
            return findSeat(from: Coordinate(i: i, j: j), direction: direction)
        default:
            return seat
        }
    }

    func occupiedSeatCount() -> Int {
        seats.flatMap { $0 }.filter(\.isOccupied).count
    }
}

extension Seat: CustomStringConvertible {
    var description: String {
        String(rawValue)
    }
}

extension Layout: CustomStringConvertible {
    var description: String {
        seats.reduce("") { result, seats in
            result + seats.map(\.description).reduce("", +) + "\n"
        }
    }
}

let input = try! String(contentsOfFile: "input.txt", encoding: .utf8)

var layout = Layout(input: input)

while true {
    let newLayout = layout.run()
    if newLayout == layout { break }
    layout = newLayout
}

print(layout.occupiedSeatCount())
