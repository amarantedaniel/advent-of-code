import AdventOfCode

struct Button { let x: Int; let y: Int }
struct Prize { let x: Int; let y: Int }

struct Game {
    let buttonA: Button
    let buttonB: Button
    let prize: Prize

    func solve() -> Int {
        let numerator = prize.y * buttonA.x - prize.x * buttonA.y
        let denominator = buttonB.y * buttonA.x - buttonB.x * buttonA.y
        let bTaps = numerator / denominator
        let aTaps = (prize.x - buttonB.x * bTaps) / buttonA.x
        guard
            aTaps * buttonA.x + bTaps * buttonB.x == prize.x,
            aTaps * buttonA.y + bTaps * buttonB.y == prize.y
        else {
            return 0
        }
        return aTaps * 3 + bTaps
    }
}

struct Day13: AdventDay {
    private func parse(input: String, extra: Int) -> [Game] {
        let regex = #/Button A: X\+(\d+), Y\+(\d+)\nButton B: X\+(\d+), Y\+(\d+)\nPrize: X=(\d+), Y=(\d+)/#
        return input.matches(of: regex).map { match in
            Game(
                buttonA: Button(x: Int(match.output.1)!, y: Int(match.output.2)!),
                buttonB: Button(x: Int(match.output.3)!, y: Int(match.output.4)!),
                prize: Prize(
                    x: Int(match.output.5)! + extra,
                    y: Int(match.output.6)! + extra
                )
            )
        }
    }

    func part1(input: String) throws -> Int {
        let games = parse(input: input, extra: 0)
        return games.reduce(0) { result, game in
            result + game.solve()
        }
    }

    func part2(input: String) throws -> Int {
        let games = parse(input: input, extra: 10_000_000_000_000)
        return games.reduce(0) { result, game in
            result + game.solve()
        }
    }
}
