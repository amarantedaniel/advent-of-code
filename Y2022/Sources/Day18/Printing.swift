import Foundation

extension Array where Element == [[Material]] {
    var formatted: String {
        var result = ""
        for z in 0 ..< self.count {
            result += "z: \(z)\n"
            result += self[z]
                .map { $0.map(\.rawValue).joined() }
                .joined(separator: "\n")
            result += "\n\n"
        }
        return result
    }
}
