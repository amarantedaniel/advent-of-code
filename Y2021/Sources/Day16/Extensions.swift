import Foundation

extension String {
    func padStart(value: String, size: Int) -> String {
        return String(repeating: value, count: size - count) + self
    }
}

extension Substring {
    func substring(from start: Int, to end: Int) -> Substring {
        return self[index(startIndex, offsetBy: start) ... index(startIndex, offsetBy: end)]
    }

    func substring(from start: Int) -> Substring {
        return self[index(startIndex, offsetBy: start)...]
    }

    func character(at position: Int) -> Character {
        return self[index(startIndex, offsetBy: position)]
    }
}
