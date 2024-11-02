import AdventOfCode
import Foundation

struct Cube {
    let x: Int
    let y: Int
    let z: Int
}

enum Material: String {
    case air = "."
    case lava = "#"
    case water = "~"
}

struct Day18: AdventDay {
    func part1(input: String) -> Int {
        let (cubes, grid) = Parser.parse(input: input)
        return cubes.reduce(0) {
            $0 + countExposedSides(from: $1, grid: grid, material: .air)
        }
    }

    func part2(input: String) -> Int {
        let (cubes, grid) = Parser.parse(input: input)
        let filled = fill(grid: grid, from: Cube(x: 0, y: 0, z: 0))
        return cubes.reduce(0) {
            $0 + countExposedSides(from: $1, grid: filled, material: .water)
        }
    }

    private func getOpenNeighboors(from cube: Cube, grid: [[[Material]]]) -> [Cube] {
        var neighboors: [Cube] = []
        for (xx, yy, zz) in neighboorPositions() {
            let cube = Cube(x: cube.x + xx, y: cube.y + yy, z: cube.z + zz)
            if !isOutsideBounds(cube: cube, grid: grid), grid[cube.z][cube.y][cube.x] == .air {
                neighboors.append(cube)
            }
        }
        return neighboors
    }

    private func countExposedSides(from cube: Cube, grid: [[[Material]]], material: Material) -> Int {
        var count = 0
        for (xx, yy, zz) in neighboorPositions() {
            let cube = Cube(x: cube.x + xx, y: cube.y + yy, z: cube.z + zz)
            if isOutsideBounds(cube: cube, grid: grid) {
                count += 1
            } else if grid[cube.z][cube.y][cube.x] == material {
                count += 1
            }
        }
        return count
    }

    private func neighboorPositions() -> [(Int, Int, Int)] {
        [(-1, 0, 0), (1, 0, 0), (0, -1, 0), (0, 1, 0), (0, 0, -1), (0, 0, 1)]
    }

    private func isOutsideBounds(cube: Cube, grid: [[[Material]]]) -> Bool {
        cube.z < 0
            || cube.z >= grid.count
            || cube.y < 0
            || cube.y >= grid[cube.z].count
            || cube.x < 0
            || cube.x >= grid[cube.z][cube.y].count
    }

    func fill(grid: [[[Material]]], from cube: Cube) -> [[[Material]]] {
        var grid = grid
        var queue: [Cube] = [cube]
        while !queue.isEmpty {
            let cube = queue.removeFirst()
            grid[cube.z][cube.y][cube.x] = .water
            let neighboors = getOpenNeighboors(from: cube, grid: grid)
            for neighboor in neighboors {
                grid[neighboor.z][neighboor.y][neighboor.x] = .water
            }
            queue.append(contentsOf: neighboors)
        }
        return grid
    }
}
