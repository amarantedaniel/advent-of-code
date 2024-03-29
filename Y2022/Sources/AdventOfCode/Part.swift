import ArgumentParser

enum Part: ExpressibleByArgument {
    init?(argument: String) {
        switch Int(argument) {
        case 1:
            self = .part1
        case 2:
            self = .part2
        default:
            return nil
        }
    }

    case part1
    case part2
}
