struct Range {
    let from: Int
    let to: Int

    func contains(number: Int) -> Bool {
        number >= from && number <= to
    }
}
