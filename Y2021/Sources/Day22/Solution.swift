import Foundation

extension ClosedRange {
    func intersection(_ other: ClosedRange) -> ClosedRange? {
        if self.contains(other.lowerBound) {
            return other.lowerBound...Swift.min(self.upperBound, other.upperBound)
        }
        if other.contains(self.lowerBound) {
            return self.lowerBound...Swift.min(self.upperBound, other.upperBound)
        }
        return nil
    }
}

struct Cube {

    let on: Bool

    let x: ClosedRange<Int>
    let y: ClosedRange<Int>
    let z: ClosedRange<Int>

    var isValid: Bool {
        x.lowerBound >= -50 && x.upperBound <= 50 &&
            y.lowerBound >= -50 && y.upperBound <= 50 &&
            z.lowerBound >= -50 && z.upperBound <= 50
    }

    var volume: Int {
        x.count * y.count * z.count
    }

    func intersection(_ other: Cube) -> Cube? {
        guard let xIntersection = x.intersection(other.x) else { return nil }
        guard let yIntersection = y.intersection(other.y) else { return nil }
        guard let zIntersection = z.intersection(other.z) else { return nil }
        return Cube(on: other.on, x: xIntersection, y: yIntersection, z: zIntersection)
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
    let cubes = Parser.parse(input: input)
    var turnedOn: Set<Coordinate> = []
    for cube in cubes where cube.isValid {
        let coordinates = cube.coordinates
        if cube.on {
            turnedOn.formUnion(coordinates)
        } else {
            turnedOn.subtract(coordinates)
        }
    }
    return turnedOn.count
}

func calculateVolume(cube: Cube, cubes: [Cube]) -> Int {
    if cubes.isEmpty {
        return cube.on ? cube.volume : 0
    }
    if cube.on {
        return cube.volume - calculateVolume(cubes: cubes.compactMap { cube.intersection($0) })
    } else {
        return -calculateVolume(cubes: cubes.compactMap { cube.intersection($0) })
    }
}

func calculateVolume(cubes: [Cube]) -> Int {
    var acc = 0
    for (i, cube) in cubes.enumerated() {
        print(acc)
        acc += calculateVolume(cube: cube, cubes: Array(cubes[...(i - 1)]))
    }
    return acc
}

func solve2(input: String) -> Int {
    let cubes = Parser.parse(input: input)
    return calculateVolume(cubes: cubes)
}
