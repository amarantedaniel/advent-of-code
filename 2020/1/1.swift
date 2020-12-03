import Foundation

func multiplyEntries(values: [Int]) -> Int {
    for elem1 in input {
        for elem2 in input {
            for elem3 in input {
                if elem1 + elem2 + elem3 == 2020 {
                    return elem1 * elem2 * elem3
                }
            }
        }
    }
    fatalError()
}

let input = try! String(contentsOfFile: "input.txt", encoding: .utf8)
                    .split(separator: "\n")
                    .compactMap { Int($0) }

print(multiplyEntries(values: input))
