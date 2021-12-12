typealias Password = String

struct Policy {
    let letter: Character
    let restrictions: [Int]

    func validateMinMax(password: String) -> Bool {
        let min = restrictions[0]
        let max = restrictions[1]
        var count = 0
        for character in password where character == letter {
            count += 1
        }
        return count >= min && count <= max
    }

    func validatePositions(password: String) -> Bool {
        var count = 0
        for restriction in restrictions {
            let index = password.index(password.startIndex, offsetBy: restriction - 1)
            if password[index] == letter {
                count += 1
            }
        }
        return count == 1
    }
}
