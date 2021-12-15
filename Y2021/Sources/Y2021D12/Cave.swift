import Foundation

class Cave {
    let identifier: String
    let variant: Variant

    var neighboors: Set<Cave> = []
    var visited = false

    init(identifier: String) {
        self.identifier = identifier
        self.variant = Variant(identifier: identifier)
        if case .start = variant {
            visited = true
        }
    }

    func visit() {
        if case .small = variant {
            visited = true
        }
    }
}

extension Cave {
    enum Variant {
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
}

extension Cave: Hashable {
    func hash(into hasher: inout Hasher) {
        identifier.hash(into: &hasher)
    }

    static func == (lhs: Cave, rhs: Cave) -> Bool {
        lhs.identifier == rhs.identifier
    }
}

extension Cave: CustomStringConvertible {
    var description: String {
        return "id: \(identifier), visited: \(visited)"
    }
}
