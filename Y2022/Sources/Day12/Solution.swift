import Foundation
import Shared

struct Node {
    let character: Character
    let value: Int
    var isVisited = false

    init(character: Character) {
        self.character = character
        switch character {
        case "S":
            self.value = Int(Character("a").asciiValue!)
        case "E":
            self.value = Int(Character("z").asciiValue!)
        default:
            self.value = Int(character.asciiValue!)
        }
    }
}

private func parse(input: String) -> [[Node]] {
    input.split(separator: "\n").reduce(into: []) { matrix, line in
        matrix.append(
            Array(line).map { character in
                Node(character: character)
            }
        )
    }
}

struct Point: Hashable {
    let x: Int
    let y: Int
}

private func find(character: Character, in grid: [[Node]]) -> Point? {
    for y in 0..<grid.count {
        for x in 0..<grid[y].count {
            if grid[y][x].character == character {
                return Point(x: x, y: y)
            }
        }
    }
    return nil
}

private func getNeighboors(from current: Point, in grid: [[Node]]) -> [Point] {
    var neighboors: [Point] = []
    for (xx, yy) in [(-1, 0), (1, 0), (0, -1), (0, 1)] {
        let point = Point(x: current.x + xx, y: current.y + yy)
        if point.y >= 0, point.y < grid.count, point.x >= 0, point.x < grid[current.y].count {
            neighboors.append(point)
        }
    }
    return neighboors
}

func find(start: Point, grid: [[Node]], canWalk: (Node, Node) -> Bool) -> [Point: Int] {
    var steps: [Point: Int] = [:]
    for y in 0..<grid.count {
        for x in 0..<grid[y].count {
            steps[Point(x: x, y: y)] = Int.max
        }
    }
    steps[start] = 0
    var heap = Heap<Point, Int>(priority: <)
    heap.insert(start, priority: 0)
    while !heap.isEmpty {
        let current = heap.extract()!
        let node = grid[current.y][current.x]
        for point in getNeighboors(from: current, in: grid) {
            let neighboor = grid[point.y][point.x]
            if canWalk(node, neighboor) {
                let count = steps[current]! + 1
                if count < steps[point]! {
                    steps[point] = count
                    heap.insert(point, priority: count)
                }
            }
        }
    }
    return steps
}

func solve1(input: String) -> Int {
    let grid = parse(input: input)
    let start = find(character: "S", in: grid)!
    let end = find(character: "E", in: grid)!
    let result = find(start: start, grid: grid, canWalk: { from, to in
        to.value - from.value <= 1
    })
    return result[end]!
}

func solve2(input: String) -> Int {
    let grid = parse(input: input)
    let end = find(character: "E", in: grid)!
    let result = find(start: end, grid: grid, canWalk: { from, to in
        from.value - to.value <= 1
    })
    var minimum = Int.max
    for y in 0..<grid.count {
        for x in 0..<grid[y].count {
            let point = Point(x: x, y: y)
            if grid[y][x].character == "a", let steps = result[point] {
                minimum = min(minimum, steps)
            }
        }
    }
    return minimum
}
