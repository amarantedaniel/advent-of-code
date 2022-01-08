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

    func contains(_ other: ClosedRange) -> Bool {
        return contains(other.lowerBound) && contains(other.upperBound)
    }
}

struct Cube {

    let on: Bool

    let x: ClosedRange<Int>
    let y: ClosedRange<Int>
    let z: ClosedRange<Int>

    var volume: Int {
        on ? x.count * y.count * z.count : 0
    }

    func intersection(_ other: Cube) -> Cube? {
        guard let xIntersection = x.intersection(other.x) else { return nil }
        guard let yIntersection = y.intersection(other.y) else { return nil }
        guard let zIntersection = z.intersection(other.z) else { return nil }
        return Cube(on: other.on, x: xIntersection, y: yIntersection, z: zIntersection)
    }
}

func calculateVolume(cube: Cube, previousCubes cubes: ArraySlice<Cube>) -> Int {
    let volume = cube.on ? cube.volume : 0
    if cubes.isEmpty {
        return volume
    }
    let intersections = cubes.compactMap(cube.intersection(_:))
    return volume - calculateVolume(cubes: intersections)
}

func calculateVolume(cubes: [Cube]) -> Int {
    var acc = 0
    for (i, cube) in cubes.enumerated() {
        acc += calculateVolume(cube: cube, previousCubes: cubes[...(i - 1)])
    }
    return acc
}

func solve1(input: String) -> Int {
    let cubes = Parser.parse(input: input)
    let validCubes = cubes.filter { cube in
        (-50...50).contains(cube.x) && (-50...50).contains(cube.y) && (-50...50).contains(cube.z)
    }
    return calculateVolume(cubes: validCubes)
}

func solve2(input: String) -> Int {
    let cubes = Parser.parse(input: input)
    return calculateVolume(cubes: cubes)
}
