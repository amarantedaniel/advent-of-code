import AdventOfCode



struct Day11: AdventDay {
    func parse(input: String) -> Matrix {
        input.split(separator: "\n").reduce(into: []) { matrix, line in
            matrix.append(Array(line).compactMap(\.wholeNumberValue))
        }
    }

    func cleanup(matrix: inout Matrix) {
        matrix.forEach { coordinate in
            if matrix.get(coordinate) > 9 {
                matrix.set(0, at: coordinate)
            }
        }
    }

    func runIteration(matrix: inout Matrix) -> Int {
        var flashCounter = 0
        matrix.forEach { coordinate in
            matrix.increment(coordinate)
            if matrix.get(coordinate) == 10 {
                flashCounter += 1
                flashCounter += explode(matrix: &matrix, at: coordinate)
            }
        }
        return flashCounter
    }

    private func explode(matrix: inout Matrix, at coordinate: Coordinate) -> Int {
        var flashCounter = 0
        for neighboor in matrix.neighboors(coordinate: coordinate) {
            matrix.increment(neighboor)
            if matrix.get(neighboor) == 10 {
                flashCounter += 1
                flashCounter += explode(matrix: &matrix, at: neighboor)
            }
        }
        return flashCounter
    }

    func part1(input: String) -> Int {
        var matrix = parse(input: input)
        var flashCounter = 0
        for _ in 1 ... 100 {
            flashCounter += runIteration(matrix: &matrix)
            cleanup(matrix: &matrix)
        }
        return flashCounter
    }

    func part2(input: String) -> Int {
        var matrix = parse(input: input)
        var iteration = 1
        while true {
            if runIteration(matrix: &matrix) == 100 {
                return iteration
            }
            cleanup(matrix: &matrix)
            iteration += 1
        }
    }

}
