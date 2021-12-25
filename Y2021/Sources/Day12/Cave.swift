import Foundation

class Cave {
    let identifier: String
    let type: CaveType

    var neighboors: Set<Cave> = []
    var visited = false

    init(identifier: String) {
        self.identifier = identifier
        self.type = CaveType(identifier: identifier)
        if case .start = type {
            visited = true
        }
    }

    func visit() {
        if case .small = type {
            visited = true
        }
    }

    func unvisit() {
        visited = false
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
