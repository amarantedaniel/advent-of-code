import Foundation

enum Parser {
    static func parse(input: String) -> ([Cube], [[[Material]]]) {
        let cubes = input.split(separator: "\n")
            .map { line in
                let elements = line.split(separator: ",").compactMap { Int($0) }
                return Cube(x: elements[0], y: elements[1], z: elements[2])
            }
        let grid = buildGrid(cubes: cubes)
        return (cubes, grid)
    }

    private static func buildGrid(cubes: [Cube]) -> [[[Material]]] {
        let maxX = cubes.map(\.x).max()!
        let maxY = cubes.map(\.y).max()!
        let maxZ = cubes.map(\.z).max()!
        var grid = Array(
            repeating: Array(
                repeating: Array(repeating: Material.air, count: maxX + 2),
                count: maxY + 2
            ),
            count: maxZ + 2
        )
        for cube in cubes {
            grid[cube.z][cube.y][cube.x] = .lava
        }
        return grid
    }
}
