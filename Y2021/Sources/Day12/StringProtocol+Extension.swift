import Foundation

extension StringProtocol {
    var isLowercase: Bool {
        return self == self.lowercased()
    }
}
