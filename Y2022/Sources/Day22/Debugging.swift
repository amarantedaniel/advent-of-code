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

func format(cube: Cube, player: Player) -> String {
    var result: [[Square]] = []
    var top = cube.top
    if player.grid == \.top {
        top[player.position.y][player.position.x] = .player
    }
    var bottom = cube.bottom
    if player.grid == \.bottom {
        bottom[player.position.y][player.position.x] = .player
    }
    var right = cube.right
    if player.grid == \.right {
        right[player.position.y][player.position.x] = .player
    }
    var left = cube.left
    if player.grid == \.left {
        left[player.position.y][player.position.x] = .player
    }
    var front = cube.front
    if player.grid == \.front {
        front[player.position.y][player.position.x] = .player
    }
    var back = cube.back
    if player.grid == \.back {
        back[player.position.y][player.position.x] = .player
    }
    let size = cube.top.count
    let empties = Array(repeating: Square.outside, count: size)
    for line in top {
        result.append(empties + line)
    }
    for i in 0..<size {
        result.append(left[i] + front[i] + right[i])
    }
    for line in bottom {
        result.append(empties + line)
    }
    for line in back {
        result.append(empties + line)
    }
    let string = result
        .map { $0.map { String($0.rawValue) }.joined() }
        .joined(separator: "\n")
    return string + "\n"
}
