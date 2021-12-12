import Foundation

enum Validator {
    static func validate(string: String?, between start: Int, and end: Int) -> Bool {
        guard let string = string, let number = Int(string) else { return false }
        return number >= start && number <= end
    }

    static func validate(string: String?, matches regex: String) -> Bool {
        guard
            let string = string,
            let regex = try? NSRegularExpression(pattern: regex)
        else { return false }
        let range = NSRange(location: 0, length: string.utf16.count)
        return regex.firstMatch(in: string, options: [], range: range) != nil
    }
}
