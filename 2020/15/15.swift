import Foundation

let input = try! String(contentsOfFile: "input.txt", encoding: .utf8)
let numbers = input.split(separator: ",").compactMap { Int($0) }

var dict: [Int: Int] = [:]
for (index, number) in numbers.enumerated() {
    dict[number] = index
}

var current = 0
for index in numbers.count ..< 30_000_000 - 1 {
    if let lastIndex = dict[current] {
        dict[current] = index
        current = index - lastIndex
    } else {
        dict[current] = index
        current = 0
    }
}

print(current)
