extension Map where Value: CustomStringConvertible {
    func render() {
        for y in 0..<map.count {
            for x in 0..<map[y].count {
                print(map[y][x].description, terminator: "")
            }
            print()
        }
        print()
    }
}

extension Square: CustomStringConvertible {
    var description: String {
        String(rawValue)
    }
}

extension SquareV2: CustomStringConvertible {
    var description: String {
        String(rawValue)
    }
}
