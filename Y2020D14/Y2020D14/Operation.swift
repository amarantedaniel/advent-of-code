struct Operation {
    let mask: String
    let number: Int

    func execute() -> Int {
        let binary = String(number, radix: 2).padStart(mask.count)
        return Int(String(zip(Array(binary), Array(mask)).map { $1 == "X" ? $0 : $1 }), radix: 2)!
    }
}
