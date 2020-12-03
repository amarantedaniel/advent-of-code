import Foundation

typealias Mountain = [[Square]]
typealias Position = (x: Int, y: Int)
typealias Strategy = (right: Int, down: Int)

enum Square: Character, CustomStringConvertible {
    case open = "."
    case tree = "#"
    
    var description: String {
        String(rawValue)
    }
}

func parseInput(input: String) -> Mountain {
    input.split(separator: "\n").map {
        $0.compactMap(Square.init(rawValue:))
    }
}

func slideDown(mountain: Mountain, from currentPosition: Position, using strategy: Strategy) -> Int {
    let position = Position(
        x: (currentPosition.x + strategy.right) % mountain[0].count, 
        y: currentPosition.y + strategy.down
    )
    guard position.y < mountain.count else { return 0 }
    switch mountain[position.y][position.x] {
    case .open:
        return 0 + slideDown(mountain: mountain, from: position, using: strategy)
    case .tree:
        return 1 + slideDown(mountain: mountain, from: position, using: strategy)
    }
}

let input = try! String(contentsOfFile: "input.txt", encoding: .utf8)
var mountain = parseInput(input: input)

let strategies = [
    Strategy(right: 1, down: 1),
    Strategy(right: 3, down: 1),
    Strategy(right: 5, down: 1),
    Strategy(right: 7, down: 1),
    Strategy(right: 1, down: 2)
]

let result = strategies
                .map { slideDown(mountain: mountain, from: Position(x: 0, y: 0), using: $0) }
                .reduce(1, *)

print(result)
