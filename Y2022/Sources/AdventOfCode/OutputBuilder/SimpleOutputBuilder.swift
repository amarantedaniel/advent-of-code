import Foundation

struct SimpleOutputBuilder: OutputBuilder {
    var output: [String] = []
    mutating func set(day: String) {
        output.append(day)
    }

    mutating func set(result: Result<AdventDayResult, Error>, for part: Part) {
        switch result {
        case let .success(result):
            let duration = result.duration.formatted(.units(allowed: [.milliseconds]))
            output.append("\(part): \(result.result) (\(duration)")
        case let .failure(failure):
            output.append("\(part): failed: \(failure)")
        }
    }

    func build() -> String {
        output.joined(separator: "\n")
    }
}
