import AdventOfCode

struct Point: Equatable { let x: Int; let y: Int }

enum Square: Character {
    case wall = "#"
    case path = "."
}

enum Parser {
    static func parse(input: String) -> (Point, Point, [[Square]]) {
        var start: Point!
        var end: Point!
        var map: [[Square]] = []
        for (y, line) in input.split(separator: "\n").enumerated() {
            var row: [Square] = []
            for (x, character) in line.enumerated() {
                switch character {
                case "S":
                    start = Point(x: x, y: y)
                    row.append(.path)
                case "E":
                    end = Point(x: x, y: y)
                    row.append(.path)
                default:
                    row.append(Square(rawValue: character)!)
                }
            }
            map.append(row)
        }
        return (start, end, map)
    }

}

struct Day16: AdventDay {
    func part1(input: String) throws -> String {
        let (start, end, map) = Parser.parse(input: input)
        print(start)
        print(end)
        throw AdventError.notImplemented
    }

    func part2(input: String) throws -> String {
        throw AdventError.notImplemented
    }
}
