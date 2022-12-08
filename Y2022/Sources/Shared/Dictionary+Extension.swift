import Foundation

public extension Dictionary where Value == Int {
    mutating func increment(at index: Key, amount: Int = 1) {
        self[index] = (self[index] ?? 0) + amount
    }
}
