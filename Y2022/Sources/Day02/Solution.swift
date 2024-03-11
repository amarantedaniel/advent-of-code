import AdventDay
import Foundation

enum Move: Int {
    case rock = 1
    case paper = 2
    case scissors = 3

    init(text: Substring) {
        switch text {
        case "A", "X":
            self = .rock
        case "B", "Y":
            self = .paper
        case "C", "Z":
            self = .scissors
        default:
            fatalError()
        }
    }
}

enum Result: Int {
    case win = 6
    case lose = 0
    case draw = 3

    init(text: Substring) {
        switch text {
        case "X":
            self = .lose
        case "Y":
            self = .draw
        case "Z":
            self = .win
        default:
            fatalError()
        }
    }
}

struct Match {
    let player: Move
    let oponent: Move
    let result: Result

    init(oponent: Move, player: Move) {
        self.player = player
        self.oponent = oponent
        switch (player, oponent) {
        case (.rock, .rock), (.paper, .paper), (.scissors, .scissors):
            result = .draw
        case (.paper, .rock), (.rock, .scissors), (.scissors, .paper):
            result = .win
        case (.rock, .paper), (.scissors, .rock), (.paper, .scissors):
            result = .lose
        }
    }

    init(oponent: Move, result: Result) {
        self.oponent = oponent
        self.result = result
        switch (oponent, result) {
        case (.rock, .win), (.paper, .draw), (.scissors, .lose):
            player = .paper
        case (.scissors, .win), (.rock, .draw), (.paper, .lose):
            player = .rock
        case (.paper, .win), (.scissors, .draw), (.rock, .lose):
            player = .scissors
        }
    }

    func calculate() -> Int {
        player.rawValue + result.rawValue
    }
}

public struct Day02: AdventDay {
    public init() {}

    public func part1(input: String) -> Int {
        parse(input: input)
            .reduce(0) { $0 + $1.calculate() }
    }

    public func part2(input: String) -> Int {
        parse2(input: input)
            .reduce(0) { $0 + $1.calculate() }
    }

    private func parse(input: String) -> [Match] {
        input
            .split(separator: "\n")
            .map { line in
                line.split(separator: " ").map(Move.init(text:))
            }
            .map { moves in
                Match(oponent: moves[0], player: moves[1])
            }
    }

    private func parse2(input: String) -> [Match] {
        input
            .split(separator: "\n")
            .map { line in
                let characters = line.split(separator: " ")
                let move = Move(text: characters[0])
                let result = Result(text: characters[1])
                return Match(oponent: move, result: result)
            }
    }
}
