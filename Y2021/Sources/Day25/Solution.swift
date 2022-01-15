import Foundation

enum Direction: Character {
    case east = ">"
    case south = "v"
}

struct SeaCucumber {

    var direction: Direction
    var canMove: Bool

    init?(rawValue: Character) {
        guard let direction = Direction(rawValue: rawValue) else {
            return nil
        }
        self.direction = direction
        self.canMove = false
    }
}

private func moveEast(sea: inout [[SeaCucumber?]]) -> Bool {
    var hasMoved = false
    for i in 0..<sea.count {
        for j in 0..<sea[i].count {
            let nextJ = (j + 1) % sea[i].count
            if sea[i][j]?.direction == .east, sea[i][nextJ] == nil {
                sea[i][j]?.canMove = true
                hasMoved = true
            }
        }
    }
    for i in 0..<sea.count {
        for j in 0..<sea[i].count where sea[i][j]?.canMove == true {
            let nextJ = (j + 1) % sea[i].count
            sea[i][nextJ] = sea[i][j]
            sea[i][j] = nil
            sea[i][nextJ]?.canMove = false
        }
    }
    return hasMoved
}

private func moveSouth(sea: inout [[SeaCucumber?]]) -> Bool {
    var hasMoved = false
    for i in 0..<sea.count {
        for j in 0..<sea[i].count {
            let nextI = (i + 1) % sea.count
            if sea[i][j]?.direction == .south, sea[nextI][j] == nil {
                sea[i][j]?.canMove = true
                hasMoved = true
            }
        }
    }
    for i in 0..<sea.count {
        for j in 0..<sea[i].count where sea[i][j]?.canMove == true {
            let nextI = (i + 1) % sea.count
            sea[nextI][j] = sea[i][j]
            sea[i][j] = nil
            sea[nextI][j]?.canMove = false
        }
    }
    return hasMoved
}

func move(sea: inout [[SeaCucumber?]]) -> Bool {
    let hasMovedEast = moveEast(sea: &sea)
    let hasMovedSouth = moveSouth(sea: &sea)
    return hasMovedEast || hasMovedSouth
}

func solve1(input: String) -> Int {
    var sea = Parser.parse(input: input)
    var step = 1
    while move(sea: &sea) {
        step += 1
    }
    return step
}
