import Foundation

enum Parser {
    static func parse(input: String) -> [[SeaCucumber?]] {
        input.split(separator: "\n").reduce(into: []) { matrix, line in
            matrix.append(Array(line).map(SeaCucumber.init(rawValue:)))
        }
    }
}
