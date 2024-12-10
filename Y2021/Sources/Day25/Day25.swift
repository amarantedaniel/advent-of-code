import AdventOfCode

enum SeaCucumber: Character {
    case east = ">"
    case south = "v"
}

struct Day25: AdventDay {
    private func hash(_ i: Int, _ j: Int) -> String {
        return "\(i),\(j)"
    }

    private func moveEast(sea: inout [[SeaCucumber?]]) -> Bool {
        var hasMoved = false
        var checked: Set<String> = []
        for i in 0..<sea.count {
            for j in 0..<sea[i].count {
                let nextJ = (j + 1) % sea[i].count
                if checked.contains(hash(i, j)) || checked.contains(hash(i, nextJ)) {
                    continue
                }
                if sea[i][j] == .east, sea[i][nextJ] == nil {
                    move(sea: &sea, checked: &checked, i0: i, j0: j, i1: i, j1: nextJ)
                    hasMoved = true
                }
            }
        }
        return hasMoved
    }

    private func moveSouth(sea: inout [[SeaCucumber?]]) -> Bool {
        var hasMoved = false
        var checked: Set<String> = []
        for i in 0..<sea.count {
            for j in 0..<sea[i].count {
                let nextI = (i + 1) % sea.count
                if checked.contains(hash(i, j)) || checked.contains(hash(nextI, j)) {
                    continue
                }
                if sea[i][j] == .south, sea[nextI][j] == nil {
                    move(sea: &sea, checked: &checked, i0: i, j0: j, i1: nextI, j1: j)
                    hasMoved = true
                }
            }
        }
        return hasMoved
    }

    private func move(sea: inout [[SeaCucumber?]], checked: inout Set<String>, i0: Int, j0: Int, i1: Int, j1: Int) {
        sea[i1][j1] = sea[i0][j0]
        sea[i0][j0] = nil
        checked.insert(hash(i0, j0))
        checked.insert(hash(i1, j1))
    }

    func move(sea: inout [[SeaCucumber?]]) -> Bool {
        let hasMovedEast = moveEast(sea: &sea)
        let hasMovedSouth = moveSouth(sea: &sea)
        return hasMovedEast || hasMovedSouth
    }

    func part1(input: String) -> Int {
        var sea = Parser.parse(input: input)
        var step = 1
        while move(sea: &sea) {
            step += 1
        }
        return step
    }

    func part2(input: String) throws -> Int {
        throw AdventError.notImplemented
    }
}
