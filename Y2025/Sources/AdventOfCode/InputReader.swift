import Foundation

enum InputReader {
    static func read(from bundle: Bundle) throws -> String {
        guard
            let path = bundle.path(forResource: "input", ofType: "txt"),
            let input = try? String(contentsOfFile: path, encoding: .utf8)
        else {
            throw AdventError.fileNotFound
        }
        return input
    }
}
