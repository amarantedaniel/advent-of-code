import Foundation

// typealias Position = (x: Int, y: Int, z: Int)

struct Position: Hashable, Comparable {
    let x: Int
    let y: Int
    let z: Int

    func adjacents() -> [Position] {
        var positions: [Position] = []
        let range = [-1, 0, 1]
        for x in range {
            for y in range {
                for z in range {
                    if !(x == 0 && y == 0 && z == 0) {
                        positions.append(
                            Position(x: self.x + x, y: self.y + y, z: self.z + z)
                        )
                    }
                }
            }
        }
        return positions
    }

    static func < (lhs: Position, rhs: Position) -> Bool {
        guard lhs.z == rhs.z else { return lhs.z < rhs.z }
        guard lhs.y == rhs.y else { return lhs.y < rhs.y }
        return lhs.x < rhs.x
    }
}

enum State: Character {
    case active = "#"
    case inactive = "."
}

struct Cube: CustomStringConvertible, Comparable {
    let state: State
    let position: Position

    var description: String {
        String(state.rawValue)
    }

    static func < (lhs: Cube, rhs: Cube) -> Bool {
        lhs.position < rhs.position
    }
}

let input = try! String(contentsOfFile: "input.txt", encoding: .utf8)

let cubesInput = input.split(separator: "\n").map { Array($0) }
var cubes: [Position: Cube] = [:]

for i in 0 ..< cubesInput.count {
    for j in 0 ..< cubesInput[i].count {
        let position = Position(x: j, y: i, z: 0)
        let state = State(rawValue: cubesInput[i][j])!
        cubes[position] = Cube(state: state, position: position)
    }
}

func print(cubes: [Cube]) {
    let cubes = cubes.sorted()
    var string = ""
    var prev: Cube?
    for cube in cubes {
        if let prev = prev {
            if cube.position.z > prev.position.z {
                string += "\n\n"
            }
            if cube.position.y > prev.position.y {
                string += "\n"
            }
        }
        string += cube.description
        prev = cube
    }
    print(string)
}

func run(cubes: [Position: Cube]) {
    // for (position, cube) in cubes {
    let position = Position(x: 0, y: 0, z: 0)
    let adjacents = position.adjacents()
    for adjacent in adjacents {
        print(adjacent)
        print(cubes[position])
    }
    // }
    // return cubes
}

run(cubes: cubes)
