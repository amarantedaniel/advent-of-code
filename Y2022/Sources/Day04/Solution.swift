import Foundation

struct Board: CustomStringConvertible {
    let numbers: [[Int]]
    var rows: [Set<Int>] = []
    var columns: [Set<Int>] = []

    var isFinished = false

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
        let hasSuccessInRows =  processRows(number: number)
        let hasSuccessInColumns = processColumns(number: number)
        return hasSuccessInRows || hasSuccessInColumns
    }

    private mutating func processRows(number: Int) -> Bool {
        for i in 0..<rows.count {
            rows[i].remove(number)
            if rows[i].isEmpty {
                return true
            }
        }
        return false
    }

    private mutating func processColumns(number: Int) -> Bool {
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
        return bigSet.reduce(0, +) * number
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

func findWinningBoardResult(numbers: [Int], boards: inout [Board]) -> Int {
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

func findLosingBoardResult(numbers: [Int], boards: inout [Board]) -> Int {
    for number in numbers {
        for i in 0..<boards.count where boards[i].isFinished == false {
            let count = boards.filter { !$0.isFinished }.count
            let result = boards[i].process(number: number)
            if result {
                boards[i].isFinished = true
                if count == 1 {
                    return boards[i].calculateResult(number: number)
                }
            }
        }
    }
    fatalError()
}

func solve1(input: String) -> Int {
    let lines = input.split(separator: "\n")
    let numbers = lines[0].split(separator: ",").compactMap { Int($0) }
    var boards = parseBoards(input: lines)
    return findWinningBoardResult(numbers: numbers, boards: &boards)
}

func solve2(input: String) -> Int {
    let lines = input.split(separator: "\n")
    let numbers = lines[0].split(separator: ",").compactMap { Int($0) }
    var boards = parseBoards(input: lines)
    return findLosingBoardResult(numbers: numbers, boards: &boards)
}
