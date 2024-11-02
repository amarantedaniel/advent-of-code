//
//  File.swift
//  Y2022
//
//  Created by Daniel Amarante on 2024-11-01.
//


import Foundation

func format(grid: [[Square]], player: Point? = nil) -> String {
    var grid = grid
    if let player = player {
        grid[player.y][player.x] = .player
    }
    var result = grid
        .map { $0.map(\.description).joined() }
        .joined(separator: "\n")
    result += "\n"
    return result
}

extension Square: CustomStringConvertible {
    var description: String {
        switch self {
        case .player:
            return "E"
        case .wall:
            return "#"
        case .floor:
            return "."
        case .blizzard(let directions):
            if directions.count == 1 {
                return String(directions[0].rawValue)
            } else {
                return "\(directions.count)"
            }
        }
    }
}
