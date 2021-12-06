import Foundation

struct Board: CustomStringConvertible {
    let numbers: [[Int]]
    var rows: [Set<Int>] = []
    var columns: [Set<Int>] = []

    init(numbers: [[Int]]) {
        self.numbers = numbers
        setupRows()
        setupColumns()
    }

    private mutating func setupRows() {
        for i in 0..<numbers.count {
            rows.append(Set(numbers[i]))
        }
    }

    private mutating func setupColumns() {
        for i in 0..<numbers.count {
            var column: Set<Int> = []
            for j in 0..<numbers[i].count {
                column.insert(numbers[j][i])
            }
            columns.append(column)
        }
    }

    mutating func process(number: Int) -> Bool {
        return processRow(number: number) || processColumn(number: number)
    }

    private mutating func processRow(number: Int) -> Bool {
        for i in 0..<rows.count {
            rows[i].remove(number)
            if rows[i].isEmpty {
                return true
            }
        }
        return false
    }

    private mutating func processColumn(number: Int) -> Bool {
        for i in 0..<columns.count {
            columns[i].remove(number)
            if columns[i].isEmpty {
                return true
            }
        }
        return false
    }

    func calculateResult(number: Int) -> Int {
        var bigSet: Set<Int> = []
        for row in rows {
            bigSet.formUnion(row)
        }
        for column in columns {
            bigSet.formUnion(column)
        }
        return (bigSet.reduce(0, +) - number) * number
    }

    var description: String {
        return numbers.reduce("") { partialResult, row in
            "\(partialResult)\n\(row.map(String.init(_:)).joined(separator: ", "))"
        }
    }
}

func parseBoards(input: [Substring]) -> [Board] {
    var boards: [Board] = []
    var tmp: [[Int]] = []
    for i in 1..<input.count {
        tmp.append(input[i].split(separator: " ").compactMap { Int($0) })
        if tmp.count == 5 {
            boards.append(Board(numbers: tmp))
            tmp = []
        }
    }
    return boards
}

let input = try! String(contentsOfFile: "input.txt", encoding: .utf8).split(separator: "\n")
let numbers = input[0].split(separator: ",").compactMap { Int($0) }
var boards = parseBoards(input: input)

func play(numbers: [Int], boards: inout [Board]) -> Int {
    for number in numbers {
        for i in 0..<boards.count {
            let result = boards[i].process(number: number)
            if result {
                return boards[i].calculateResult(number: number)
            }
        }
    }
    fatalError()
}

print(play(numbers: numbers, boards: &boards))
