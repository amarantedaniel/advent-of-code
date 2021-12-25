import Foundation

enum CaveType {
    case start
    case end
    case large
    case small

    init(identifier: String) {
        switch identifier {
        case "start":
            self = .start
        case "end":
            self = .end
        case _ where identifier.isLowercase:
            self = .small
        default:
            self = .large
        }
    }
}
