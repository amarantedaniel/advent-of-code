import Foundation

struct Step: CustomStringConvertible {
    let on: Bool
    let cube: Cube

    var description: String {
        let x = "x=\(cube.x.lowerBound)..\(cube.x.upperBound - 1)"
        let y = "y=\(cube.y.lowerBound)..\(cube.y.upperBound - 1)"
        let z = "z=\(cube.z.lowerBound)..\(cube.z.upperBound - 1)"
        return "\(on ? "on" : "off") \(x),\(y),\(z)"
    }
}

struct Cube {
    let x: Range<Int>
    let y: Range<Int>
    let z: Range<Int>

    var isValid: Bool {
        x.lowerBound >= -50 && x.upperBound <= 51 &&
        y.lowerBound >= -50 && y.upperBound <= 51 &&
        z.lowerBound >= -50 && z.upperBound <= 51
    }

    var coordinates: [Coordinate] {
        var result: [Coordinate] = []
        for xx in x {
            for yy in y {
                for zz in z {
                    result.append(Coordinate(x: xx, y: yy, z: zz))
                }
            }
        }
        return result
    }
}

struct Coordinate: Hashable {
    let x: Int
    let y: Int
    let z: Int
}

func solve1(input: String) -> Int {
    let steps = Parser.parse(input: input)
    var turnedOn: Set<Coordinate> = []
    for step in steps where step.cube.isValid {
        let coordinates = step.cube.coordinates
        if step.on {
            turnedOn.formUnion(coordinates)
        } else {
            turnedOn.subtract(coordinates)
        }
    }
    return turnedOn.count
}

func solve2(input: String) -> Int {
    return 0
}
