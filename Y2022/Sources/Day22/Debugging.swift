import Foundation

func format(maze: [[Square]], player: Player? = nil) -> String {
    var maze = maze
    if let player = player {
        maze[player.position.y][player.position.x] = .player
    }
    return maze
        .map { $0.map { String($0.rawValue) }.joined() }
        .joined(separator: "\n")
}
//
//func format(cube: Cube) -> String {
//    let size = cube.top.count
//    let top = format(maze: cube.top)
//    let bottom = format(maze: cube.bottom)
//    let right = format(maze: cube.right)
//    let left = format(maze: cube.left)
//    let front = format(maze: cube.front)
//    let back = format(maze: cube.back)
//    let empty = format(maze: Array(repeating: Array(repeating: Square.player, count: size), count: size))
//    return """
//    \(empty)\(top)\(empty)
//    """
//}
