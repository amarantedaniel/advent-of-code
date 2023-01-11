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
