import Foundation

extension Array where Element == [SeaCucumber?] {
    var formatted: String {
        return self
            .map { $0.map { String($0?.rawValue ?? ".") }.joined() }
            .joined(separator: "\n")
    }
}
