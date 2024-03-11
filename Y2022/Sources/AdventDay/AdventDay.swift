import Foundation

public protocol AdventDay {
    associatedtype Output: CustomStringConvertible
    func part1(input: String) throws -> Output
    func part2(input: String) throws -> Output
}

public extension AdventDay {
    var name: String { String(String(describing: self).dropLast(2)) }

    func part1(input _: String) throws -> Output {
        throw NotImplemented()
    }

    func part2(input _: String) throws -> Output {
        throw NotImplemented()
    }
}

struct NotImplemented: Error {}
