struct Passport {
    let birthYear: String?
    let issueYear: String?
    let expirationYear: String?
    let height: String?
    let hairColor: String?
    let eyeColor: String?
    let passportId: String?
    let countryId: String?

    private let requiredFields: [KeyPath<Passport, String?>] = [
        \.birthYear,
        \.issueYear,
        \.expirationYear,
        \.height,
        \.hairColor,
        \.eyeColor,
        \.passportId,
    ]

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

    func validateRequired() -> Bool {
        requiredFields
            .compactMap { self[keyPath: $0] }
            .count == 7
    }

    func validate() -> Bool {
        Validator.validate(string: birthYear, between: 1920, and: 2002)
            && Validator.validate(string: issueYear, between: 2010, and: 2020)
            && Validator.validate(string: expirationYear, between: 2020, and: 2030)
            && validateHeight()
            && Validator.validate(string: hairColor, matches: "^#(?:[0-9a-f]{3}){1,2}$")
            && Validator.validate(string: eyeColor, matches: "^amb|blu|brn|gry|grn|hzl|oth$")
            && Validator.validate(string: passportId, matches: "^\\d{9}$")
    }

    private func validateHeight() -> Bool {
        guard let height = height else { return false }
        if height.hasSuffix("cm") {
            return Validator.validate(string: String(height.dropLast(2)), between: 150, and: 193)
        }
        if height.hasSuffix("in") {
            return Validator.validate(string: String(height.dropLast(2)), between: 59, and: 76)
        }
        return false
    }
}
