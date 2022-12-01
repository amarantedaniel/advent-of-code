import Foundation

enum Parser {
    static func parse(input: String) -> (Algorithm, Image) {
        let parts = input.components(separatedBy: "\n\n")
        let algorithm = Array(parts[0]).map(\.binary)
        let bitmap = parts[1].split(separator: "\n").map(Array.init).map { $0.map(\.binary) }
        return (algorithm, Image(bitmap: bitmap))
    }
}

private extension Character {
    var binary: Int {
        switch self {
        case "#": return 1
        case ".": return 0
        default: fatalError()
        }
    }
}
