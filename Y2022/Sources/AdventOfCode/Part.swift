public enum Part {
    case part1
    case part2
    case both

    public init(value: String?) {
        switch value {
        case "1":
            self = .part1
        case "2":
            self = .part2
        default:
            self = .both
        }
    }
}
