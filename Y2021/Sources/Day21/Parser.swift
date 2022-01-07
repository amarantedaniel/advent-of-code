import Foundation

enum Parser {
    static func parse(input: String) -> (Player, Player) {
        let lines = input.split(separator: "\n")
        let positionA = Int(lines[0].split(separator: " ").last!)!
        let positionB = Int(lines[1].split(separator: " ").last!)!
        return (Player(position: positionA, score: 0), Player(position: positionB, score: 0))
    }
}
