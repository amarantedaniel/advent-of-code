import Foundation

let input = try! String(contentsOfFile: "input.txt", encoding: .utf8)
let numbers = input.split(separator: "\n").compactMap { Int($0) }.sorted()
let adapters = [0] + numbers + [numbers.last! + 3]

func countArrangements(adapters: ArraySlice<Int>, cache: inout [Int: Int]) -> Int {
    if adapters.count <= 1 { return 1 }
    if let cached = cache[adapters.startIndex] { return cached }
    let first = adapters[adapters.startIndex]
    let rest = adapters[adapters.startIndex + 1 ... min(adapters.startIndex + 3, adapters.endIndex - 1)]
    var count = 0
    for i in rest.startIndex ..< rest.endIndex where rest[i] - first <= 3 {
        count += countArrangements(adapters: adapters[i ..< adapters.endIndex], cache: &cache)
    }
    cache[adapters.startIndex] = count
    return count
}

var cache: [Int: Int] = [:]
print(countArrangements(adapters: adapters[...], cache: &cache))
