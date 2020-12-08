import Foundation

struct Passport {
    let birthYear: String?
    let issueYear: String?
    let expirationYear: String?
    let height: String?
    let hairColor: String?
    let eyeColor: String?
    let passportId: String?
    let countryId: String?

    init(input: [String: String]) {
        birthYear = input["byr"]
        issueYear = input["iyr"]
        expirationYear = input["eyr"]
        height = input["hgt"]
        hairColor = input["hcl"]
        eyeColor = input["ecl"]
        passportId = input["pid"]
        countryId = input["cid"]
    }

    func validate() -> Bool {
        let isBirthYearValid = validate(string: birthYear, between: 1920, and: 2002)
        let isIssueYearValid = validate(string: issueYear, between: 2010, and: 2020)
        let isExpirationYearValid = validate(string: expirationYear, between: 2020, and: 2030)
        let isHeightValid = validateHeight()
        let isHairColorValid = validate(string: hairColor, matches: "^#(?:[0-9a-f]{3}){1,2}$")
        let isEyeColorValid = validate(string: eyeColor, matches: "^amb|blu|brn|gry|grn|hzl|oth$")
        let isPassportIdValid = validate(string: passportId, matches: "^\\d{9}$")
        return isBirthYearValid
            && isIssueYearValid
            && isExpirationYearValid
            && isHeightValid
            && isHairColorValid
            && isEyeColorValid
            && isPassportIdValid
    }

    private func validate(string: String?, between start: Int, and end: Int) -> Bool {
        guard let string = string, let number = Int(string) else { return false }
        return number >= start && number <= end
    }

    private func validate(string: String?, matches regex: String) -> Bool {
        guard
            let string = string,
            let regex = try? NSRegularExpression(pattern: regex)
        else { return false }
        let range = NSRange(location: 0, length: string.utf16.count)
        return regex.firstMatch(in: string, options: [], range: range) != nil
    }

    private func validateHeight() -> Bool {
        guard let height = height else { return false }
        if height.hasSuffix("cm") {
            return validate(string: String(height.dropLast(2)), between: 150, and: 193)
        }
        if height.hasSuffix("in") {
            return validate(string: String(height.dropLast(2)), between: 59, and: 76)
        }
        return false
    }
}

func parsePassport(input: [Substring]) -> Passport {
    let dictionary = input.reduce(into: [String: String]()) { dict, entry in
        let keyValue = entry.split(separator: ":")
        dict[String(keyValue[0])] = String(keyValue[1])
    }
    return Passport(input: dictionary)
}

let input = try! String(contentsOfFile: "input.txt", encoding: .utf8)
let passports = input
    .components(separatedBy: "\n\n")
    .map { $0.split(separator: "\n").flatMap { $0.split(separator: " ") } }
    .map(parsePassport(input:))

print(passports.filter { $0.validate() }.count)
