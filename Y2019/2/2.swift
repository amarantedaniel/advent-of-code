import Foundation

enum Operation: Int {
    case sum = 1
    case multiply = 2
    case halt = 99
}

func runProgram(_ input: [Int], noun: Int, verb: Int) -> Int {
    var input = input
    input[1] = noun
    input[2] = verb
    for index in stride(from: 0, to: input.endIndex, by: 4) {
        switch Operation(rawValue: input[index])! {
        case .sum:
            input[input[index + 3]] = input[input[index + 1]] + input[input[index + 2]]
        case .multiply:
            input[input[index + 3]] = input[input[index + 1]] * input[input[index + 2]]
        case .halt:
            return input[0]
        }
    }
    fatalError()
}

func findParams(thatMatch result: Int, for input: [Int]) -> (noun: Int, verb: Int) {
    for noun in 0 ... 99 {
        for verb in 0 ... 99 {
            if runProgram(input, noun: noun, verb: verb) == result {
                return (noun: noun, verb: verb)
            }
        }
    }
    fatalError()
}

let input = try! String(contentsOfFile: "input.txt", encoding: .utf8)
    .split(separator: ",")
    .compactMap { Int($0) }

let (noun, verb) = findParams(thatMatch: 19_690_720, for: input)

print(100 * noun + verb)
