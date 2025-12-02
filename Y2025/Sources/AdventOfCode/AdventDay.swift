public protocol AdventDay {
    associatedtype Output: CustomStringConvertible
    func part1(input: String) async throws -> Output
    func part2(input: String) async throws -> Output
}
