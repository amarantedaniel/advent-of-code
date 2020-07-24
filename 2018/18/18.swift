let input = """
...|||......|||........#..|...|.......#||.||.#|.#|
..##.|.||...||.|.#....||..|......|.#..#||.|#..|##.
.|...|....|.|.##...|#...|...#...#.#|.#............
|#.||.|..#.#..|...#..#..|.|..#...#..#...|##....|##
.|.........#.|.#.........|..#....|..##..##........
.#|##.||.........||||#..#|#|.||...|..|...#.||...#.
...|....#...|....|#.#.#..#..#.#....#|..|#...|.|...
.|....#|.|.#|###.|..|..|.#|.###|.##..|.#....|.||..
|..|#.|..#.#...#|#....#...|..|......#|.#.|||..|#.#
....##||..#....|.|...|###.#.|.|#.|..##.....||...|.
....#.#|..#|##..#........#.#....|......###|#|##.|#
|..##.###.#.###.......|..|#|.|..|#.#....#|..|#..#|
....##.#..###.......|.|.|..#..##....#|..|...#.|...
..##...|..#.|....#.#.|###..|....|||.|.|.|....|#.#.
|..|#|....#|.#..#|.#..|.#..|#.|.|..|##|||.#.##.|..
.....#.|#|.|.#......#.#..#.#|...#.|.#|........#...
|.#.#.#..|.|.#.|||..|..|##|.##...#.|...##|...#....
..|.#..#....|..|.|.#.|#..|##.....|.....|....##..||
.|.#.#.#...||.|#...|........|..|#....#.|#..#|.|.|.
#..#.#............#.#.|.|#.||..|#....#.|.#|.##....
|.....|#..#|.|...|.#||.#||.......#.||..|.||.####..
#..#......#||.#..##...#.####..#|.#.|...|#.##|.#..|
...|..#|.||.|###...##.......|....#.|.||.|#|#..#..#
...#.#|...#|||...#|..||.#....|.|..#..|...#|.#...|.
.#|..#.|||.|##|.|#.#....|..|.|.##.#.#|#..#.#|..||#
.#.|#.#..####...|.#|#..#.|...#|#.|.##.|...##..#.||
...#..#|..##|.|#||...##||..|...##...|...|#.||..#.#
|#.....|..#..#..|.|#|...|..#.#|...#............###
||.|.|##.#|...|....#..|.|.|.#|...........|.....#|#
|..#..#..#......|....|.|......|##|.#....##.|##.|||
###.||.|.|.|..#..||....|...|..|....#..#|..|.||..|#
....#.#|||..|#|.......#|....#........####|....##.|
........|..|...#..|....#...|#.#..##|..|.#..#|.###.
.#.##.#...##|.|#.#.|.....#...#..#|.#|#|.|......#|.
.|.....###.||...#|.#.|||#|..#.|.|.#.#.##.##.|.|.|.
#.#|.||..|.#...##..||.##....#..........#...##.|...
.#....|..##..|.#.##|........#..#......#.....#|..##
.|#.#...|.|||....||...#|.|.#......#..###..|.#|.|.|
##..#.|#.|.....||..##.||#|.#|#|#....#..|...|......
..|......#.|.|.#..|........|.###||###....|.#.....|
|..|#|..|...#...##|#|#.#|#|......||###...|.#||....
.........|.##|...#.#...##....|.....#...|#..|..#..#
...#.#........#.|#..#..#|##|.....#.#.|#||...|#.|..
...##..#|..........|.....|....|#.|..#...#|...#|.#.
.|..#|..|.|.|||....|.#....|..||..#...|..#..|..##|.
....|.|...#...#..#.|.....#....|...#.|..........|..
...#|#.||.#..|#.|.###|#|.#.......#...##.##|.|....|
....##||.#...#..#...##|...||#.#..#|#......##||.|..
..#.....##.......|##.|..||#......|..|||.#.......#.
.....|#||#..|.#|..|..|....|........|.....##.#.#.|.
"""

let simpleInput = """
.#.#...|#.
.....#|##|
.|..|...#.
..|#.....#
#.#|||#|#|
...#.||...
.|....|...
||...#|.#|
|.||||..|.
...#.|..|.
"""

typealias Position = (x: Int, y: Int)
typealias Area = [[Acre]]

enum Acre: Character, CustomStringConvertible {
    case ground = "."
    case tree = "|"
    case lumberyard = "#"

    var description: String {
        String(rawValue)
    }
}

func parseInput(input: String) -> Area {
    input.split(separator: "\n").map {
        $0.compactMap(Acre.init(rawValue:))
    }
}

func run(area: Area) -> Area {
    var newArea = area
    for i in 0..<area.count {
        for j in 0..<area[i].count {
            switch area[i][j] {
            case .ground where shouldGroundBecomeTrees(at: (x: i, y: j), on: area):
                newArea[i][j] = .tree
            case .tree where shouldTreesBecomeLumberyard(at: (x: i, y: j), on: area):
                newArea[i][j] = .lumberyard
            case .lumberyard where shouldLumberyardBecomeOpen(at: (x: i, y: j), on: area):
                newArea[i][j] = .ground
            default:
                break
            }
        }
    }
    return newArea
}

func shouldGroundBecomeTrees(at position: Position, on area: Area) -> Bool {
    let adjacentAcres = getAdjacentAcres(for: position, on: area)
    return adjacentAcres.filter { $0 == .tree }.count >= 3
}

func shouldTreesBecomeLumberyard(at position: Position, on area: Area) -> Bool {
    let adjacentAcres = getAdjacentAcres(for: position, on: area)
    return adjacentAcres.filter { $0 == .lumberyard }.count >= 3
}

func shouldLumberyardBecomeOpen(at position: Position, on area: Area) -> Bool {
    let adjacentAcres = getAdjacentAcres(for: position, on: area)
    return !(adjacentAcres.contains(.lumberyard) && adjacentAcres.contains(.tree))
}

func getAdjacentAcres(for position: Position, on area: Area) -> [Acre] {
    var acres = [Acre]()
    let (x, y) = position

    if x > 0, y > 0 {
        acres.append(area[x - 1][y - 1])
    }
    if y > 0 {
        acres.append(area[x][y - 1])
    }
    if y > 0, x < area.count - 1 {
        acres.append(area[x + 1][y - 1])
    }
    if x > 0 {
        acres.append(area[x - 1][y])
    }
    if x < area.count - 1 {
        acres.append(area[x + 1][y])
    }
    if x > 0, y < area[x].count - 1 {
        acres.append(area[x - 1][y + 1])
    }
    if y < area[x].count - 1 {
        acres.append(area[x][y + 1])
    }
    if x < area.count - 1, y < area[x].count - 1 {
        acres.append(area[x + 1][y + 1])
    }

    return acres
}

func calculateResourceValue(area: Area) -> Int {
    var treeCount = 0
    var lumberyardCount = 0

    for i in 0..<area.count {
        for j in 0..<area[i].count {
            if area[i][j] == .tree {
                treeCount += 1
            }
            if area[i][j] == .lumberyard {
                lumberyardCount += 1
            }
        }
    }
    return treeCount * lumberyardCount
}

func print(area: Area) {
    print(area.reduce("") { result, acres in
        result + acres.map(\.description).reduce("", +) + "\n"
    })
}

var area = parseInput(input: input)
for _ in 1...10 {
    area = run(area: area)
    print(area: area)
}

print(calculateResourceValue(area: area))
