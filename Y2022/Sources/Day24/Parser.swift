//
//  Parser.swift
//  Y2022
//
//  Created by Daniel Amarante on 2024-11-01.
//


import Foundation

enum Parser {
    static func parse(input: String) -> [[Square]] {
        return input.split(separator: "\n").reduce(into: []) { matrix, line in
            matrix.append(Array(line).compactMap(Square.init(character:)))
        }
    }
}

private extension Square {
    init?(character: Character) {
        switch character {
        case "#":
            self = .wall
        case ".":
            self = .floor
        case "<", ">", "v", "^":
            self = .blizzard([Direction(rawValue: character)!])
        default:
            return nil
        }
    }
}
