import AdventOfCode

struct DeterministicDice {
    var current = 0

    mutating func roll() -> Int {
        current += 1
        return current
    }

    mutating func roll(times: Int) -> Int {
        return (1...times).reduce(0) { acc, _ in acc + roll() }
    }
}

struct QuantumDice {
    func roll() -> [Int] {
        var results: [Int] = []
        for i in 1...3 {
            for j in 1...3 {
                for k in 1...3 {
                    results.append(i + j + k)
                }
            }
        }
        return results
    }
}

struct Player: Equatable, Hashable {
    var position: Int
    var score: Int

    func roll(dice: QuantumDice) -> [Player] {
        return dice.roll()
            .map(newPosition(moves:))
            .map { Player(position: $0, score: score + $0) }
    }

    mutating func roll(dice: inout DeterministicDice) {
        move(times: dice.roll(times: 3))
    }

    private mutating func move(times: Int) {
        position = newPosition(moves: times)
        score += position
    }

    private func newPosition(moves: Int) -> Int {
        return ((position - 1 + moves) % 10) + 1
    }
}

enum Turn: Equatable, Hashable {
    case player1
    case player2
}

struct DeterministicGame {
    var turn: Turn = .player1
    var dice = DeterministicDice()
    var player1: Player
    var player2: Player

    var isFinished: Bool {
        player1.score >= 1_000 || player2.score >= 1_000
    }

    mutating func run() {
        switch turn {
        case .player1:
            player1.roll(dice: &dice)
            turn = .player2
        case .player2:
            player2.roll(dice: &dice)
            turn = .player1
        }
    }

    func calculateResult() -> Int {
        return min(player1.score, player2.score) * dice.current
    }
}

struct QuantumGame: Equatable, Hashable {
    let player1: Player
    let player2: Player
    let turn: Turn

    struct Result {
        var player1: Int
        var player2: Int
        static let zero = Result(player1: 0, player2: 0)

        var winner: Int { max(player1, player2) }
    }

    func run(lookup: inout [QuantumGame: QuantumGame.Result]) -> Result {
        guard player1.score < 21 else { return Result(player1: 1, player2: 0) }
        guard player2.score < 21 else { return Result(player1: 0, player2: 1) }
        if let result = lookup[self] {
            return result
        }
        let games: [QuantumGame]
        switch turn {
        case .player1:
            games = player1
                .roll(dice: QuantumDice())
                .map { QuantumGame(player1: $0, player2: player2, turn: .player2) }
        case .player2:
            games = player2
                .roll(dice: QuantumDice())
                .map { QuantumGame(player1: player1, player2: $0, turn: .player1) }
        }
        let result = games.reduce(Result.zero) {
            let result = $1.run(lookup: &lookup)
            return Result(player1: $0.player1 + result.player1, player2: $0.player2 + result.player2)
        }
        lookup[self] = result
        return result
    }
}

struct Day21: AdventDay {
    func part1(input: String) -> Int {
        let (player1, player2) = Parser.parse(input: input)
        var game = DeterministicGame(player1: player1, player2: player2)
        while true {
            game.run()
            if game.isFinished {
                return game.calculateResult()
            }
        }
        fatalError()
    }

    func part2(input: String) -> Int {
        let (player1, player2) = Parser.parse(input: input)
        let quantumGame = QuantumGame(player1: player1, player2: player2, turn: .player1)
        var lookup: [QuantumGame: QuantumGame.Result] = [:]
        return quantumGame.run(lookup: &lookup).winner
    }
}
