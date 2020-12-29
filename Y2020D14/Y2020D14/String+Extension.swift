extension String {
    func padStart(_ padding: Int) -> String {
        var padded = self
        for _ in 0 ..< (padding - count) {
            padded = "0" + padded
        }
        return padded
    }
}
