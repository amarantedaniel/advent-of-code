import Foundation

protocol OutputBuilder {
    mutating func set(day: String)
    mutating func set(result: Result<AdventDayResult, Error>, for part: Part)
    func build() -> String
}
